import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/database/db_config.dart';
import 'package:move_your_body/core/database/tables/exercise_table.dart';
import 'package:move_your_body/core/model/exercise_data.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return ExerciseRepository();
});

class ExerciseRepository {
  Future<List<Exercise>> getAllExercises() async {
    final db = await DatabaseService.instance.database;

    final maps = await db.query(ExerciseTable.tableName);

    return maps.map(Exercise.fromMap).toList();
  }
}
