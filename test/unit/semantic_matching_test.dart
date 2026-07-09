import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:move_your_body/core/database/db_config.dart';
import 'package:move_your_body/features/ai_inference/repositories/tag_setup_repository.dart';
import 'package:move_your_body/features/ai_inference/repositories/ai_repository.dart';
import 'package:move_your_body/core/model/tag_data.dart';
import 'package:move_your_body/core/database/tables/tags_table.dart';

final _kneePainQuery       = [0.98, 0.10, 0.02, 0.05, 0.01, 0.00, 0.03, 0.00];
final _kneeInjuryTag       = [0.97, 0.12, 0.03, 0.04, 0.02, 0.01, 0.02, 0.01];
final _shoulderInjuryTag   = [0.05, 0.06, 0.90, 0.30, 0.05, 0.01, 0.02, 0.00];

final _strongerShouldersQuery = [0.05, 0.05, 0.92, 0.32, 0.06, 0.01, 0.00, 0.00];
final _upperBodyTag           = [0.04, 0.06, 0.93, 0.33, 0.05, 0.01, 0.01, 0.00];
final _fatBurnTag             = [0.80, 0.55, 0.10, 0.05, 0.01, 0.02, 0.00, 0.01];

final _cardioQuery        = [0.10, 0.92, 0.10, 0.20, 0.05, 0.02, 0.01, 0.00];
final _cardioEnduranceTag = [0.11, 0.91, 0.09, 0.22, 0.04, 0.01, 0.02, 0.00];
final _strengthTag        = [0.20, 0.15, 0.85, 0.42, 0.07, 0.03, 0.02, 0.01];

Uint8List _toBytes(List<double> v) =>
    Float32List.fromList(v).buffer.asUint8List();

class FakeDatabase extends Fake implements Database {
  final List<Map<String, dynamic>> rows;
  FakeDatabase(this.rows);

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
  }) async => rows;
}

class SemanticMockAiRepo extends Fake implements AiModelRepository {
  final Map<String, List<double>> _embeddings;
  SemanticMockAiRepo(this._embeddings);

  @override
  Future<void> initModel() async {}

  @override
  Future<Uint8List?> generateEmbedding(String text) async {
    final vec = _embeddings[text.trim().toLowerCase()];
    if (vec == null) return null;
    return Float32List.fromList(vec).buffer.asUint8List();
  }
}

ProviderContainer _makeContainer({
  required FakeDatabase fakeDb,
  required SemanticMockAiRepo aiRepo,
}) {
  return ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(fakeDb),
      aiModelRepositoryProvider.overrideWithValue(aiRepo),
    ],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Semantic Matching — end-to-end pipeline (User text → Top-K tags)', () {
    group('"I have knee pain" → knee_injury', () {
      test('top match is knee_injury, not an unrelated tag', () async {
        final fakeDb = FakeDatabase([
          {TagsTable.id: 1, TagsTable.tagName: 'knee_injury', TagsTable.tagType: TagType.injury.name, TagsTable.embedding: _toBytes(_kneeInjuryTag)},
          {TagsTable.id: 2, TagsTable.tagName: 'shoulder_injury', TagsTable.tagType: TagType.injury.name, TagsTable.embedding: _toBytes(_shoulderInjuryTag)},
        ]);
        final aiRepo = SemanticMockAiRepo({'i have knee pain': _kneePainQuery});
        final container = _makeContainer(fakeDb: fakeDb, aiRepo: aiRepo);
        addTearDown(container.dispose);

        final userEmbedding = await container
            .read(aiModelRepositoryProvider)
            .generateEmbedding('I have knee pain');

        final results = await container.read(tagSetupRepositoryProvider).findTopMatches(
              type: TagType.injury,
              userEmbedding: userEmbedding,
              threshold: 0.60,
              limit: 3,
            );

        expect(results, contains('knee_injury'));
        expect(results.first, equals('knee_injury'));
        expect(results, isNot(contains('shoulder_injury')));
      });
    });

    group('"I want stronger shoulders" → upper_body, not fat_burn', () {
      test('top match is upper_body with fat_burn filtered out', () async {
        final fakeDb = FakeDatabase([
          {TagsTable.id: 1, TagsTable.tagName: 'upper_body', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: _toBytes(_upperBodyTag)},
          {TagsTable.id: 2, TagsTable.tagName: 'fat_burn', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: _toBytes(_fatBurnTag)},
        ]);
        final aiRepo = SemanticMockAiRepo({'i want stronger shoulders': _strongerShouldersQuery});
        final container = _makeContainer(fakeDb: fakeDb, aiRepo: aiRepo);
        addTearDown(container.dispose);

        final userEmbedding = await container
            .read(aiModelRepositoryProvider)
            .generateEmbedding('I want stronger shoulders');

        final results = await container.read(tagSetupRepositoryProvider).findTopMatches(
              type: TagType.goal,
              userEmbedding: userEmbedding,
              threshold: 0.60,
              limit: 3,
            );

        expect(results, contains('upper_body'));
        expect(results.first, equals('upper_body'));
        expect(results, isNot(contains('fat_burn')));
      });
    });

    group('"I struggle to breathe during cardio" → cardio_endurance, not strength', () {
      test('cardio_endurance is matched and strength is filtered out', () async {
        final fakeDb = FakeDatabase([
          {TagsTable.id: 1, TagsTable.tagName: 'cardio_endurance', TagsTable.tagType: TagType.injury.name, TagsTable.embedding: _toBytes(_cardioEnduranceTag)},
          {TagsTable.id: 2, TagsTable.tagName: 'strength', TagsTable.tagType: TagType.injury.name, TagsTable.embedding: _toBytes(_strengthTag)},
        ]);
        final aiRepo = SemanticMockAiRepo({'i struggle to breathe during cardio': _cardioQuery});
        final container = _makeContainer(fakeDb: fakeDb, aiRepo: aiRepo);
        addTearDown(container.dispose);

        final userEmbedding = await container
            .read(aiModelRepositoryProvider)
            .generateEmbedding('I struggle to breathe during cardio');

        final results = await container.read(tagSetupRepositoryProvider).findTopMatches(
              type: TagType.injury,
              userEmbedding: userEmbedding,
              threshold: 0.60,
              limit: 3,
            );

        expect(results, contains('cardio_endurance'));
        expect(results.first, equals('cardio_endurance'));
        expect(results, isNot(contains('strength')));
      });
    });

    group('Top-K ranking is enforced', () {
      test('returns at most K results even when more match the threshold', () async {
        final fakeDb = FakeDatabase([
          {TagsTable.id: 1, TagsTable.tagName: 'tag_a', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: _toBytes([1.00, 0.00])},
          {TagsTable.id: 2, TagsTable.tagName: 'tag_b', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: _toBytes([0.99, 0.14])},
          {TagsTable.id: 3, TagsTable.tagName: 'tag_c', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: _toBytes([0.98, 0.20])},
          {TagsTable.id: 4, TagsTable.tagName: 'tag_d', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: _toBytes([0.97, 0.24])},
        ]);
        final aiRepo = SemanticMockAiRepo({'general query': [1.0, 0.0]});
        final container = _makeContainer(fakeDb: fakeDb, aiRepo: aiRepo);
        addTearDown(container.dispose);

        final userEmbedding = await container
            .read(aiModelRepositoryProvider)
            .generateEmbedding('general query');

        final results = await container.read(tagSetupRepositoryProvider).findTopMatches(
              type: TagType.goal,
              userEmbedding: userEmbedding,
              threshold: 0.50,
              limit: 2,
            );

        expect(results, hasLength(2));
        expect(results[0], equals('tag_a'));
        expect(results[1], equals('tag_b'));
      });

      test('results are always ordered highest-similarity first', () async {
        final fakeDb = FakeDatabase([
          {TagsTable.id: 1, TagsTable.tagName: 'low_sim',  TagsTable.tagType: TagType.goal.name, TagsTable.embedding: _toBytes([0.80, 0.60])},
          {TagsTable.id: 2, TagsTable.tagName: 'high_sim', TagsTable.tagType: TagType.goal.name, TagsTable.embedding: _toBytes([1.00, 0.00])},
          {TagsTable.id: 3, TagsTable.tagName: 'mid_sim',  TagsTable.tagType: TagType.goal.name, TagsTable.embedding: _toBytes([0.95, 0.31])},
        ]);
        final aiRepo = SemanticMockAiRepo({'ordered query': [1.0, 0.0]});
        final container = _makeContainer(fakeDb: fakeDb, aiRepo: aiRepo);
        addTearDown(container.dispose);

        final userEmbedding = await container
            .read(aiModelRepositoryProvider)
            .generateEmbedding('ordered query');

        final results = await container.read(tagSetupRepositoryProvider).findTopMatches(
              type: TagType.goal,
              userEmbedding: userEmbedding,
              threshold: 0.50,
              limit: 5,
            );

        expect(results[0], equals('high_sim'));
        expect(results[1], equals('mid_sim'));
        expect(results[2], equals('low_sim'));
      });
    });
  });
}
