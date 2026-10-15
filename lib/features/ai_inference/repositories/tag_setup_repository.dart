import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/ai_inference/repositories/ai_repository.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/db_config.dart';
import '../../../../core/database/tables/tags_table.dart';
import '../../../core/model/tag_data.dart';

final tagSetupRepositoryProvider = Provider((ref) => TagSetupRepository(ref));

class TagSetupRepository {
  final Ref _ref;
  TagSetupRepository(this._ref);

  Future<void> processAndSeedTags() async {
    final db = await DatabaseService.instance.database;

    final String jsonString = await rootBundle.loadString(
      'assets/exercises/exercises.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final List<dynamic> exercises = jsonData['exercises'] ?? [];

    final Set<String> uniqueGoals = {};
    final Set<String> uniqueInjuries = {};

    for (var ex in exercises) {
      final String goalStr = ex['goal_tags'] ?? '';
      if (goalStr.isNotEmpty) {
        uniqueGoals.addAll(goalStr.split(';').map((e) => e.trim()));
      }

      final String contraStr = ex['contraindications'] ?? '';
      if (contraStr.isNotEmpty) {
        uniqueInjuries.addAll(contraStr.split(';').map((e) => e.trim()));
      }
    }
    debugPrint(
      "Tag seeding: ${uniqueGoals.length} goals, "
      "${uniqueInjuries.length} injuries found",
    );
    await _processSet(db, uniqueGoals, TagType.goal);
    await _processSet(db, uniqueInjuries, TagType.injury);
  }

  Future<void> _processSet(Database db, Set<String> tags, TagType type) async {
    final aiRepo = _ref.read(aiModelRepositoryProvider);

    // Load every cached tag of this type in one query instead of one query
    // per tag.
    final List<Map<String, dynamic>> existingRows = await db.query(
      TagsTable.tableName,
      columns: [TagsTable.tagName],
      where: '${TagsTable.tagType} = ? AND ${TagsTable.embedding} IS NOT NULL',
      whereArgs: [type.name],
    );
    final Set<String> cached = existingRows
        .map((row) => row[TagsTable.tagName] as String)
        .toSet();

    final List<Tag> newTags = [];
    int failed = 0;

    for (String tagName in tags) {
      if (tagName.isEmpty || cached.contains(tagName)) continue;

      final Uint8List? embeddingBytes = await aiRepo.generateEmbedding(tagName);
      if (embeddingBytes == null) {
        failed++;
        continue;
      }
      newTags.add(
        Tag(tagName: tagName, tagType: type, embedding: embeddingBytes),
      );
    }

    if (newTags.isNotEmpty) {
      final batch = db.batch();
      for (final tag in newTags) {
        batch.insert(TagsTable.tableName, tag.toMap());
      }
      await batch.commit(noResult: true);
    }

    debugPrint(
      "Tag seeding [${type.name}]: ${cached.length} cached, "
      "${newTags.length} embedded, $failed failed",
    );
  }

  Future<void> debugPrintAllCachedTags() async {
    try {
      final db = await DatabaseService.instance.database;

      final List<Map<String, dynamic>> maps = await db.query(
        TagsTable.tableName,
      );

      debugPrint("================ DB VERIFICATION START ================");
      debugPrint("Total Tags Found in Database: ${maps.length}");

      if (maps.isEmpty) {
        debugPrint("❌ No tags found in the database.");
        debugPrint("=====================================================");
        return;
      }

      for (var map in maps) {
        final tag = Tag.fromMap(map);

        final int embeddingLength = tag.embedding?.length ?? 0;

        debugPrint(
          "📌 ID: ${tag.id} | Name: ${tag.tagName} | Type: ${tag.tagType.name} | Embedding Size: $embeddingLength bytes",
        );
      }
      debugPrint("================= DB VERIFICATION END =================");
    } catch (e) {
      debugPrint("❌ Error reading tags from database: $e");
    }
  }
}
