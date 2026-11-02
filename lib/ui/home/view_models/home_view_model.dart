import 'dart:async';
import 'package:move_your_body/data/repositories/exercise_repository.dart';
import 'package:move_your_body/data/repositories/session_repository.dart';
import 'package:move_your_body/data/repositories/user_repository.dart';
import 'package:move_your_body/domain/models/enums/exercise_enums.dart';
import 'package:move_your_body/domain/models/exercise_data.dart';
import 'package:move_your_body/domain/models/home_state.dart';
import 'package:move_your_body/domain/models/session_data.dart';
import 'package:move_your_body/domain/models/user_data.dart';
import 'package:move_your_body/utils/equipment_filter.dart';
import 'package:move_your_body/utils/safety_filter_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeState> build() async {
    return _initialize();
  }

  Future<HomeState> _initialize() async {
    final now = DateTime.now();
    final currentWeekday = now.weekday;
    final firstDayOfWeek = now.subtract(Duration(days: currentWeekday % 7));

    final days = List.generate(
      7,
      (index) => firstDayOfWeek.add(Duration(days: index)),
    );

    final sessionRepo = ref.read(sessionRepositoryProvider);
    final incompleteSession = await sessionRepo.getLatestIncompleteSession();

    if (incompleteSession != null) {
      final exerciseRepo = ref.read(exerciseRepositoryProvider.notifier);
      final exerciseIds = incompleteSession.exercises
          .map((e) => e.exerciseId)
          .toList();
      final exercises = await exerciseRepo.getExercisesByIds(exerciseIds);

      return HomeState(
        selectedDate: now,
        currentWeekDays: days,
        recommendedExercises: exercises,
        currentSession: incompleteSession,
        hasIncompleteSession: true,
      );
    }

    final userRepo = ref.read(userRepositoryProvider.notifier);
    final userData = await userRepo.getUserData();

    if (userData == null) {
      throw Exception('User onboarding data not found.');
    }

    final localSessionRepo = ref.read(sessionRepositoryProvider);
    final recentExerciseIds = await localSessionRepo.getRecentExerciseIds(
      SafetyFilter.sessionsToSkip,
    );
    final exercises = await _recommendExercises(userData, recentExerciseIds);

    return HomeState(
      selectedDate: now,
      currentWeekDays: days,
      recommendedExercises: exercises,
      hasIncompleteSession: false,
    );
  }

  Future<List<Exercise>> _recommendExercises(
    UserData user,
    List<String> recentExerciseIds,
  ) async {
    final exerciseRepo = ref.read(exerciseRepositoryProvider.notifier);
    final safetyFilterService = ref.read(safetyFilterProvider);
    final equipmentFilterService = ref.read(equipmentFilterProvider);

    var exercises = await exerciseRepo.getAllExercises();
    exercises = safetyFilterService.filterExercises(
      exercises: exercises,
      user: user,
      recentExerciseIds: recentExerciseIds,
    );
    exercises = equipmentFilterService.filterExercises(
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
    return (matchedGoals / user.goalTags.length) * 5.0;
  }

  double _bodyRegionScore(UserData user, Exercise exercise) {
    if (user.targetBodyRegion.isEmpty) return 0;
    final userRegions = user.targetBodyRegion
        .map((e) => BodyRegion.values.byName(e))
        .toSet();
    final matchedRegions = exercise.bodyRegions
        .where(userRegions.contains)
        .length;
    return (matchedRegions / userRegions.length) * 3.0;
  }

  double _difficultyScore(UserData user, Exercise exercise) {
    return user.difficulty == exercise.difficulty.name ? 2.0 : 0;
  }

  double _intensityScore(UserData user, Exercise exercise) {
    return user.intensity == exercise.intensity.name ? 1.5 : 0;
  }

  Future<Session?> createSession() async {
    final current = state.asData?.value;
    if (current == null) return null;
    if (current.hasIncompleteSession && current.currentSession != null) {
      return current.currentSession;
    }

    state = AsyncData(current.copyWith(isCreatingSession: true));
    try {
      final sessionRepo = ref.read(sessionRepositoryProvider);
      final session = await sessionRepo.createSessionFromExercises(
        current.recommendedExercises,
      );

      if (session != null) {
        state = AsyncData(
          current.copyWith(
            currentSession: session,
            hasIncompleteSession: true,
            isCreatingSession: false,
          ),
        );
      } else {
        state = AsyncData(current.copyWith(isCreatingSession: false));
      }
      return session;
    } catch (e) {
      state = AsyncData(current.copyWith(isCreatingSession: false));
      return null;
    }
  }
}

class _ScoredExercise {
  final Exercise exercise;
  final double score;

  const _ScoredExercise({required this.exercise, required this.score});
}
