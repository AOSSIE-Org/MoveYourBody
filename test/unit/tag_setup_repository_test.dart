import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:move_your_body/core/database/db_config.dart';
import 'package:move_your_body/features/ai_inference/repositories/tag_setup_repository.dart';
import 'package:move_your_body/core/model/tag_data.dart';
import 'package:move_your_body/core/database/tables/tags_table.dart';

class FakeDatabase extends Fake implements Database {
  final List<Map<String, dynamic>> _rows;
  final List<Map<String, dynamic>> insertedRows = [];
  final List<Map<String, dynamic>> updatedRows = [];

  FakeDatabase(this._rows);

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    return _rows;
  }

  @override
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    insertedRows.add(values);
    return insertedRows.length;
  }

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    updatedRows.add(values);
    return 1;
  }
}

ProviderContainer makeContainer(FakeDatabase fakeDb) {
  return ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(fakeDb),
    ],
  );
}

Uint8List floatListToBytes(List<double> values) {
  return Float32List.fromList(values).buffer.asUint8List();
}

void main() {
  group('TagSetupRepository — findTopMatches (Riverpod DI)', () {
    test('returns tags above threshold, sorted by score descending', () async {
      final fakeDb = FakeDatabase([
        {
          TagsTable.id: 1,
          TagsTable.tagName: 'Perfect Match',
          TagsTable.tagType: TagType.goal.name,
          TagsTable.embedding: floatListToBytes([1.0, 0.0]),
        },
        {
          TagsTable.id: 2,
          TagsTable.tagName: 'Below Threshold',
          TagsTable.tagType: TagType.goal.name,
          TagsTable.embedding: floatListToBytes([0.0, 1.0]),
        },
        {
          TagsTable.id: 3,
          TagsTable.tagName: 'Partial Match',
          TagsTable.tagType: TagType.goal.name,
          TagsTable.embedding: floatListToBytes([0.8, 0.6]),
        },
      ]);
      final container = makeContainer(fakeDb);
      addTearDown(container.dispose);

      final results = await container.read(tagSetupRepositoryProvider).findTopMatches(
            type: TagType.goal,
            userEmbedding: floatListToBytes([1.0, 0.0]),
            threshold: 0.60,
            limit: 5,
          );

      expect(results, hasLength(2));
      expect(results[0], equals('Perfect Match'));
      expect(results[1], equals('Partial Match'));
    });

    test('respects the limit parameter', () async {
      final fakeDb = FakeDatabase([
        {TagsTable.id: 1, TagsTable.tagName: 'Tag A', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: floatListToBytes([1.0, 0.0])},
        {TagsTable.id: 2, TagsTable.tagName: 'Tag B', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: floatListToBytes([0.99, 0.14])},
        {TagsTable.id: 3, TagsTable.tagName: 'Tag C', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: floatListToBytes([0.9, 0.43])},
      ]);
      final container = makeContainer(fakeDb);
      addTearDown(container.dispose);

      final results = await container.read(tagSetupRepositoryProvider).findTopMatches(
            type: TagType.goal,
            userEmbedding: floatListToBytes([1.0, 0.0]),
            threshold: 0.50,
            limit: 2,
          );

      expect(results, hasLength(2));
    });

    test('returns empty list when userEmbedding is null', () async {
      final container = makeContainer(FakeDatabase([]));
      addTearDown(container.dispose);

      final results = await container.read(tagSetupRepositoryProvider).findTopMatches(
            type: TagType.goal,
            userEmbedding: null,
          );

      expect(results, isEmpty);
    });

    test('returns empty list when userEmbedding is empty bytes', () async {
      final container = makeContainer(FakeDatabase([]));
      addTearDown(container.dispose);

      final results = await container.read(tagSetupRepositoryProvider).findTopMatches(
            type: TagType.goal,
            userEmbedding: Uint8List(0),
          );

      expect(results, isEmpty);
    });

    test('filters out tags with no embedding stored', () async {
      final fakeDb = FakeDatabase([
        {TagsTable.id: 1, TagsTable.tagName: 'Tag With Embedding', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: floatListToBytes([1.0, 0.0])},
        {TagsTable.id: 2, TagsTable.tagName: 'Tag Without Embedding', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: null},
      ]);
      final container = makeContainer(fakeDb);
      addTearDown(container.dispose);

      final results = await container.read(tagSetupRepositoryProvider).findTopMatches(
            type: TagType.goal,
            userEmbedding: floatListToBytes([1.0, 0.0]),
            threshold: 0.0,
            limit: 5,
          );

      expect(results, hasLength(1));
      expect(results.first, equals('Tag With Embedding'));
    });

    test('injury and goal tags are queried independently', () async {
      final fakeDb = FakeDatabase([
        {TagsTable.id: 1, TagsTable.tagName: 'fat_burn', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: floatListToBytes([1.0, 0.0])},
        {TagsTable.id: 2, TagsTable.tagName: 'knee_injury', TagsTable.tagType: TagType.injury.name, TagsTable.embedding: floatListToBytes([1.0, 0.0])},
      ]);
      final container = makeContainer(fakeDb);
      addTearDown(container.dispose);

      final goalResults = await container.read(tagSetupRepositoryProvider).findTopMatches(
            type: TagType.goal,
            userEmbedding: floatListToBytes([1.0, 0.0]),
            threshold: 0.50,
            limit: 5,
          );
      final injuryResults = await container.read(tagSetupRepositoryProvider).findTopMatches(
            type: TagType.injury,
            userEmbedding: floatListToBytes([1.0, 0.0]),
            threshold: 0.50,
            limit: 5,
          );

      expect(goalResults, isNotEmpty);
      expect(injuryResults, isNotEmpty);
    });
  });
}
