import 'dart:io';
import 'package:move_your_body/data/database/db_config.dart';
import 'package:move_your_body/data/database/tables/exercise_table.dart';
import 'package:move_your_body/domain/models/exercise_data.dart';
import 'package:move_your_body/data/services/animation_cache_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/exercise_repository.g.dart';

@Riverpod(keepAlive: true)
class ExerciseRepository extends _$ExerciseRepository {
  final DatabaseService? _customDbService;

  ExerciseRepository([this._customDbService]);

  DatabaseService get _dbService =>
      _customDbService ?? ref.read(databaseServiceProvider);

  @override
  Future<List<Exercise>> build() async {
    return _fetchFromDb();
  }

  Future<List<Exercise>> _fetchFromDb() async {
    final maps = await _dbService.queryExercisesDb(ExerciseTable.tableName);
    return maps.map(Exercise.fromMap).toList();
  }

  Future<List<Exercise>> getAllExercises() async {
    try {
      final current = state.asData?.value;
      if (current != null) return current;
      return await future;
    } catch (_) {
      return await _fetchFromDb();
    }
  }

  Future<List<Exercise>> getExercisesByIds(List<String> exerciseIds) async {
    if (exerciseIds.isEmpty) return [];

    final all = await getAllExercises();
    final exerciseMap = {for (final e in all) e.exerciseId: e};

    return exerciseIds
        .where((id) => exerciseMap.containsKey(id))
        .map((id) => exerciseMap[id]!)
        .toList();
  }

  Future<File> getAnimationFile(String url) async {
    return await AnimationCacheService.getFile(url);
  }
}
