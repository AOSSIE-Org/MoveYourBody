import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/database/tables/exercise_table.dart';
import 'package:move_your_body/core/database/tables/user_table.dart';
import '../../../../core/database/db_config.dart';
import '../../../../core/database/tables/tags_table.dart';
import '../../../core/model/tag_data.dart';
import '../services/cosine_similairty.dart';

final tagRepositoryProvider = Provider((ref) => TagRepository());

class TagMatch {
  final Tag tag;
  final double score;

  const TagMatch({required this.tag, required this.score});
}

class TagRepository {
  static const double defaultSimilarityThreshold = 0.60;
  static const int defaultTopMatchLimit = 5;

  Future<void> debugPrintAllCachedTags() async {
    try {
      final db = await DatabaseService.instance.exercisesDatabase;

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

  Future<void> debugPrintExercises() async {
    final db = await DatabaseService.instance.exercisesDatabase;
    final result = await db.query(ExerciseTable.tableName);
    debugPrint('Total exercises: ${result.length}');
    for (final exercise in result) {
      debugPrint(exercise.toString());
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

      final db = await DatabaseService.instance.exercisesDatabase;
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
    final db = await DatabaseService.instance.userDatabase;
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
