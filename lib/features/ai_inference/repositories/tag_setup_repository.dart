import 'dart:convert';
import 'dart:typed_data';
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

  static const double defaultSimilarityThreshold = 0.60;
  static const int defaultTopMatchLimit = 5;

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
    print(uniqueGoals.length);
    print(uniqueInjuries.length);
    await _processSet(db, uniqueGoals, TagType.goal);
    await _processSet(db, uniqueInjuries, TagType.injury);
  }

  Future<void> _processSet(Database db, Set<String> tags, TagType type) async {
    final aiRepo = _ref.read(aiModelRepositoryProvider);

    for (String tagName in tags) {
      if (tagName.isEmpty) continue;
      final List<Map<String, dynamic>> existing = await db.query(
        TagsTable.tableName,
        where: '${TagsTable.tagName} = ? AND ${TagsTable.tagType} = ?',
        whereArgs: [tagName, type.name],
      );
      if (existing.isEmpty) {
        final Uint8List? embeddingBytes = await aiRepo.generateEmbedding(
          tagName,
        );

        if (embeddingBytes != null) {
          final newTag = Tag(
            tagName: tagName,
            tagType: type,
            embedding: embeddingBytes,
          );

          await db.insert(TagsTable.tableName, newTag.toMap());
          print("Local Inference Complete & Cached: [$type] $tagName");
        }
      } else {
        print(
          "Entry found in Cache, skipping model inference: [$type] $tagName",
        );
      }
    }
  }

  Future<void> debugPrintAllCachedTags() async {
    try {
      final db = await DatabaseService.instance.database;

      final List<Map<String, dynamic>> maps = await db.query(
        TagsTable.tableName,
      );

      print("================ DB VERIFICATION START ================");
      print("Total Tags Found in Database: ${maps.length}");

      if (maps.isEmpty) {
        print("❌ No tags found in the database.");
        print("=====================================================");
        return;
      }

      for (var map in maps) {
        final tag = Tag.fromMap(map);

        final int embeddingLength = tag.embedding?.length ?? 0;

        print(
          "📌 ID: ${tag.id} | Name: ${tag.tagName} | Type: ${tag.tagType.name} | Embedding Size: $embeddingLength bytes",
        );
      }
      print("================= DB VERIFICATION END =================");
    } catch (e) {
      print("❌ Error reading tags from database: $e");
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
