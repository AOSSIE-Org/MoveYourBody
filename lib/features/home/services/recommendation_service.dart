import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/user_data.dart';
import 'package:move_your_body/features/home/services/equipment_filter_service.dart';
import 'package:move_your_body/features/home/services/safety_filter_service.dart';

import '../repositories/exercise_repository.dart';

final recommendationServiceProvider = Provider<RecommendationService>((ref) {
  return RecommendationService(
    ref.read(exerciseRepositoryProvider),
    ref.read(safetyFilterServiceProvider),
    ref.read(equipmentFilterServiceProvider),
  );
});

class RecommendationWeights {
  static const goal = 5.0;
  static const bodyRegion = 3.0;
  static const difficulty = 2.0;
  static const intensity = 1.5;
}

class RecommendationService {
  final ExerciseRepository _exerciseRepository;
  final SafetyFilterService _safetyFilterService;
  final EquipmentFilterService _equipmentFilterService;

  RecommendationService(
    this._exerciseRepository,
    this._safetyFilterService,
    this._equipmentFilterService,
  );

  Future<List<Exercise>> recommendExercises(UserData user, List<String> recentExerciseIds) async {
    var exercises = await _exerciseRepository.getAllExercises();
    exercises = _safetyFilterService.filterExercises(
      exercises: exercises,
      user: user,
      recentExerciseIds: recentExerciseIds,
    );
    exercises = _equipmentFilterService.filterExercises(
      exercises: exercises,
      user: user,
    );
    final scoredExercises = <_ScoredExercise>[];

    for (final exercise in exercises) {
      final score = _calculateScore(user, exercise);

      scoredExercises.add(_ScoredExercise(exercise: exercise, score: score));
    }

    scoredExercises.sort((a, b) => b.score.compareTo(a.score));

    return scoredExercises.take(3).map((e) => e.exercise).toList();
  }

  double _calculateScore(UserData user, Exercise exercise) {
    double score = 0;

    score += _goalScore(user, exercise);
    score += _bodyRegionScore(user, exercise);
    score += _difficultyScore(user, exercise);
    score += _intensityScore(user, exercise);

    return score;
  }

  double _goalScore(UserData user, Exercise exercise) {
    if (user.goalTags.isEmpty) return 0;

    final matchedGoals = user.goalTags
        .where((goal) => exercise.goalTags.contains(goal))
        .length;

    return (matchedGoals / user.goalTags.length) * RecommendationWeights.goal;
  }

  double _bodyRegionScore(UserData user, Exercise exercise) {
    if (user.targetBodyRegion.isEmpty) return 0;

    final userRegions = user.targetBodyRegion
        .map((e) => BodyRegion.values.byName(e))
        .toSet();

    final matchedRegions = exercise.bodyRegions
        .where(userRegions.contains)
        .length;

    return (matchedRegions / userRegions.length) *
        RecommendationWeights.bodyRegion;
  }

  double _difficultyScore(UserData user, Exercise exercise) {
    return user.difficulty == exercise.difficulty.name
        ? RecommendationWeights.difficulty
        : 0;
  }

  double _intensityScore(UserData user, Exercise exercise) {
    return user.intensity == exercise.intensity.name
        ? RecommendationWeights.intensity
        : 0;
  }
}

class _ScoredExercise {
  final Exercise exercise;
  final double score;

  const _ScoredExercise({required this.exercise, required this.score});
}
