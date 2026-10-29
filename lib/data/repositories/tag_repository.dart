import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/data/database/tables/user_table.dart';
import 'package:move_your_body/data/database/db_config.dart';
import 'package:move_your_body/data/database/tables/tags_table.dart';
import 'package:move_your_body/domain/models/tag_data.dart';
import 'package:move_your_body/utils/cosine_similairty.dart';

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final dbService = ref.read(databaseServiceProvider);
  return TagRepository(dbService);
});

class TagRepository {
  final DatabaseService _dbService;

  TagRepository(this._dbService);

  static const double defaultSimilarityThreshold = 0.60;
  static const int defaultTopMatchLimit = 5;

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

      final userVector = _bytesToFloatVector(userEmbedding);

      if (userVector.isEmpty) {
        return [];
      }

      final maps = await _dbService.queryExercisesDb(
        TagsTable.tableName,
        where: '${TagsTable.tagType} = ?',
        whereArgs: [type.name],
      );

      final matches = <TagMatch>[];

      for (final map in maps) {
        final tag = Tag.fromMap(map);
        if (tag.embedding == null || tag.embedding!.isEmpty) continue;

        final tagVector = _bytesToFloatVector(tag.embedding!);
        final score = SimilarityHelper.calculateCosineSimilarity(
          userVector,
          tagVector,
        );

        if (score >= threshold) {
          matches.add(TagMatch(tag: tag, score: score));
        }
      }

      matches.sort((a, b) => b.score.compareTo(a.score));
      debugPrint("Found ${matches.length} matches:");
      for (final match in matches) {
        debugPrint("${match.tag.tagName} -> ${match.score.toStringAsFixed(4)}");
      }
      return matches.take(limit).map((m) => m.tag.tagName).toList();
    } catch (e) {
      debugPrint("❌ Error finding top matches: $e");
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
    await _dbService.updateUserDb(
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
