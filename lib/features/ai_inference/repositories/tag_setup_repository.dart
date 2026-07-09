import 'dart:convert';
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
}
