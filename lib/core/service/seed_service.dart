import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/db_config.dart';
import '../database/tables/exercise_table.dart';
import '../model/exercise_data.dart';

final seedServiceProvider = Provider<SeedService>((ref) {
  return SeedService(ref);
});

class SeedService {
  final Ref _ref;
  SeedService(this._ref);

  Future<void> seedExercises() async {
    try {
      final db = _ref.read(databaseProvider);

      final existingExercises = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${ExerciseTable.tableName}',
      );
      final count = existingExercises.first['count'] as int;
      if (count > 0) {
        debugPrint('Exercises already seeded. Skipping seeding.');
        return;
      }
      final jsonString = await rootBundle.loadString(
        'assets/exercises/exercises.json',
      );

      final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>;
      final exercisesJson = decodedJson['exercises'] as List<dynamic>;
      final exercises = exercisesJson
          .map((json) => Exercise.fromJson(json as Map<String, dynamic>))
          .toList();
      final Batch batch = db.batch();
      for (final exercise in exercises) {
        batch.insert(
          ExerciseTable.tableName,
          exercise.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      await batch.commit(noResult: true);
      debugPrint('${exercises.length} exercises seeded successfully.');
    } catch (e, stackTrace) {
      debugPrint('Exercise seeding failed: $e');
      debugPrint(stackTrace.toString());
    }
  }

  Future<void> debugPrintExercises() async {
    final db = _ref.read(databaseProvider);
    final result = await db.query(ExerciseTable.tableName);
    debugPrint('Total exercises: ${result.length}');
    for (final exercise in result) {
      debugPrint(exercise.toString());
    }
  }
}
