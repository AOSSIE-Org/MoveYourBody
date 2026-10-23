import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/data/database/db_config.dart';
import 'package:move_your_body/data/database/tables/exercise_table.dart';
import 'package:move_your_body/domain/models/exercise_data.dart';
import 'package:move_your_body/data/services/animation_cache_service.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final dbService = ref.read(databaseServiceProvider);
  return ExerciseRepository(dbService);
});

class ExerciseRepository {
  final DatabaseService _dbService;

  ExerciseRepository([DatabaseService? dbService])
      : _dbService = dbService ?? DatabaseService.instance;

  Future<List<Exercise>> getAllExercises() async {
    final maps = await _dbService.getAllExerciseRecords();
    return maps.map(Exercise.fromMap).toList();
  }

  Future<List<Exercise>> getExercisesByIds(List<String> exerciseIds) async {
    if (exerciseIds.isEmpty) return [];

    final maps = await _dbService.getExerciseRecordsByIds(exerciseIds);

    final exerciseMap = {
      for (final map in maps)
        map[ExerciseTable.exerciseId] as String: Exercise.fromMap(map),
    };

    return exerciseIds
        .where((id) => exerciseMap.containsKey(id))
        .map((id) => exerciseMap[id]!)
        .toList();
  }

  Future<File> getAnimationFile(String url) async {
    return await AnimationCacheService.getFile(url);
  }
}
