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

  Future<List<Exercise>> getExercisesByIds(List<String> exerciseIds) async {
    if (exerciseIds.isEmpty) return [];
    
    final db = await DatabaseService.instance.database;
    final placeholders = List.filled(exerciseIds.length, '?').join(', ');
    
    final maps = await db.query(
      ExerciseTable.tableName,
      where: '${ExerciseTable.exerciseId} IN ($placeholders)',
      whereArgs: exerciseIds,
    );
    
    final exerciseMap = {
      for (final map in maps) 
        map[ExerciseTable.exerciseId] as String: Exercise.fromMap(map)
    };
    
    return exerciseIds
        .where((id) => exerciseMap.containsKey(id))
        .map((id) => exerciseMap[id]!)
        .toList();
  }
}
