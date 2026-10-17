import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/database/tables/user_table.dart';
import 'package:move_your_body/features/ai_inference/repositories/ai_repository.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/db_config.dart';
import '../../../../core/database/tables/tags_table.dart';
import '../../../core/model/tag_data.dart';
import '../services/cosine_similairty.dart';

final tagSetupRepositoryProvider = Provider((ref) => TagSetupRepository(ref));

class TagMatch {
  final Tag tag;
  final double score;

  const TagMatch({required this.tag, required this.score});
}

class TagSetupRepository {
  final Ref _ref;
  TagSetupRepository(this._ref);

  /// Calibrated for mean-pooled, L2-normalized MiniLM embeddings: exact
  /// matches score ~1.0, close paraphrases ~0.5-0.8, unrelated tags < 0.4.
  static const double defaultSimilarityThreshold = 0.45;
  static const int defaultTopMatchLimit = 5;

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

      // Tags are stored as snake_case ids; embed them as natural text so they
      // line up with free-form user input.
      final Uint8List? embeddingBytes = await aiRepo.generateEmbedding(
        tagName.replaceAll('_', ' '),
      );
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

  Future<List<String>> findTopMatches({
    required TagType type,
    required Uint8List? userEmbedding,
    double threshold = defaultSimilarityThreshold,
    int limit = defaultTopMatchLimit,
  }) async {
    try {
      if (userEmbedding == null || userEmbedding.isEmpty) {
        return [];
      }

      final db = await DatabaseService.instance.database;
      final userVector = _bytesToFloatVector(userEmbedding);

      if (userVector.isEmpty) {
        return [];
      }

      final maps = await db.query(
        TagsTable.tableName,
        where: '${TagsTable.tagType} = ?',
        whereArgs: [type.name],
      );

      final matches = <TagMatch>[];

      for (final map in maps) {
        final tag = Tag.fromMap(map);
        if (tag.embedding == null || tag.embedding!.isEmpty) continue;

        final tagVector = _bytesToFloatVector(tag.embedding!);
        final score = SimilarityUtils.calculateCosineSimilarity(
          userVector,
          tagVector,
        );

        if (score >= threshold) {
          matches.add(TagMatch(tag: tag, score: score));
        }
      }

      matches.sort((a, b) => b.score.compareTo(a.score));
      print("Found ${matches.length} matches:");
      for (final match in matches) {
        print("${match.tag.tagName} -> ${match.score.toStringAsFixed(4)}");
      }
      return matches.take(limit).map((m) => m.tag.tagName).toList();
    } catch (e) {
      print("❌ Error finding top matches: $e");
      return [];
    }
  }

  List<double> _bytesToFloatVector(Uint8List bytes) {
    if (bytes.lengthInBytes % 4 != 0) {
      return [];
    }

    final byteData = ByteData.sublistView(bytes);
    return List<double>.generate(
      bytes.lengthInBytes ~/ 4,
      (index) => byteData.getFloat32(index * 4, Endian.host),
    );
  }

  Future<void> updateResolvedTags({
    required List<String> goals,
    required List<String> injuries,
  }) async {
    final db = await DatabaseService.instance.database;
    await db.update(
      UserTable.tableName,
      {
        UserTable.goalTags: goals.join(','),
        UserTable.healthIssueTags: injuries.join(','),
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}
