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

  /// Runs [processAndSeedTags], retrying tags that failed to embed, and
  /// returns whether every tag ended up with a cached embedding.
  Future<bool> ensureTagsSeeded({int maxAttempts = 2}) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      if (await processAndSeedTags()) return true;
      debugPrint("Tag seeding incomplete (attempt $attempt/$maxAttempts)");
    }
    return false;
  }

  /// Embeds and caches every goal/injury tag from the exercise data.
  ///
  /// Returns `true` only when every tag has a cached embedding. Tags that
  /// fail are left without one, so they are retried on the next call.
  Future<bool> processAndSeedTags() async {
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
    // Load every existing tag in one query instead of one query per tag.
    // `tag_name` is unique across types, so rows are keyed by name only.
    final List<Map<String, dynamic>> existingRows = await db.query(
      TagsTable.tableName,
      columns: [TagsTable.tagName, TagsTable.embedding],
    );
    final Map<String, bool> existing = {
      for (final row in existingRows)
        row[TagsTable.tagName] as String: row[TagsTable.embedding] != null,
    };

    final goalFailures = await _processSet(
      db,
      uniqueGoals,
      TagType.goal,
      existing,
    );
    final injuryFailures = await _processSet(
      db,
      uniqueInjuries,
      TagType.injury,
      existing,
    );
    return goalFailures + injuryFailures == 0;
  }

  /// Embeds tags that are missing or have a null embedding, and returns the
  /// number of tags that could not be embedded.
  Future<int> _processSet(
    Database db,
    Set<String> tags,
    TagType type,
    Map<String, bool> existing,
  ) async {
    final aiRepo = _ref.read(aiModelRepositoryProvider);

    final batch = db.batch();
    int cached = 0;
    int inserted = 0;
    int updated = 0;
    int failed = 0;

    for (String tagName in tags) {
      if (tagName.isEmpty) continue;
      final hasEmbedding = existing[tagName];
      if (hasEmbedding == true) {
        cached++;
        continue;
      }

      final Uint8List? embeddingBytes = await aiRepo.generateEmbedding(tagName);
      if (embeddingBytes == null) {
        failed++;
        continue;
      }

      if (hasEmbedding == false) {
        // Row exists without an embedding: fill it in rather than inserting
        // a duplicate name.
        batch.update(
          TagsTable.tableName,
          {TagsTable.embedding: embeddingBytes},
          where: '${TagsTable.tagName} = ?',
          whereArgs: [tagName],
        );
        updated++;
      } else {
        batch.insert(
          TagsTable.tableName,
          Tag(
            tagName: tagName,
            tagType: type,
            embedding: embeddingBytes,
          ).toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        inserted++;
      }
      existing[tagName] = true;
    }

    if (inserted + updated > 0) {
      await batch.commit(noResult: true);
    }

    debugPrint(
      "Tag seeding [${type.name}]: $cached cached, $inserted inserted, "
      "$updated updated, $failed failed",
    );
    return failed;
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
