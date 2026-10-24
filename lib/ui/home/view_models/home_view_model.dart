import 'package:move_your_body/data/repositories/exercise_repository.dart';
import 'package:move_your_body/data/repositories/session_repository.dart';
import 'package:move_your_body/data/repositories/user_repository.dart';
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
  HomeState build() {
    final now = DateTime.now();
    final currentWeekday = now.weekday;
    final firstDayOfWeek = now.subtract(Duration(days: currentWeekday % 7));

    final days = List.generate(
      7,
      (index) => firstDayOfWeek.add(Duration(days: index)),
    );

    Future.microtask(() => _initialize());

    return HomeState(selectedDate: now, currentWeekDays: days);
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final sessionRepo = ref.read(sessionRepositoryProvider);
      final incompleteSession = await sessionRepo.getLatestIncompleteSession();

      if (incompleteSession != null) {
        final exerciseRepo = ref.read(exerciseRepositoryProvider);
        final exerciseIds = incompleteSession.exercises
            .map((e) => e.exerciseId)
            .toList();
        final exercises = await exerciseRepo.getExercisesByIds(exerciseIds);

        state = state.copyWith(
          recommendedExercises: exercises,
          currentSession: incompleteSession,
          hasIncompleteSession: true,
          isLoading: false,
        );
        return;
      }

      final userRepo = ref.read(userRepositoryProvider);
      final userData = await userRepo.getUserData();

      if (userData == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'User onboarding data not found.',
        );
        return;
      }

      final localSessionRepo = ref.read(sessionRepositoryProvider);
      final recentExerciseIds = await localSessionRepo.getRecentExerciseIds(
        SafetyFilter.sessionsToSkip,
      );
      final exercises = await _recommendExercises(userData, recentExerciseIds);

      state = state.copyWith(
        recommendedExercises: exercises,
        hasIncompleteSession: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<List<Exercise>> _recommendExercises(
    UserData user,
    List<String> recentExerciseIds,
  ) async {
    final exerciseRepo = ref.read(exerciseRepositoryProvider);
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
    if (state.hasIncompleteSession && state.currentSession != null) {
      return state.currentSession;
    }

    state = state.copyWith(isCreatingSession: true);
    try {
      final sessionRepo = ref.read(sessionRepositoryProvider);
      final session = await sessionRepo.createSessionFromExercises(
        state.recommendedExercises,
      );

      if (session != null) {
        state = state.copyWith(
          currentSession: session,
          hasIncompleteSession: true,
          isCreatingSession: false,
        );
      } else {
        state = state.copyWith(
          isCreatingSession: false,
          errorMessage: 'Failed to create session.',
        );
      }
      return session;
    } catch (e) {
      state = state.copyWith(
        isCreatingSession: false,
        errorMessage: 'Failed to create session: $e',
      );
      return null;
    }
  }
}

class _ScoredExercise {
  final Exercise exercise;
  final double score;

  const _ScoredExercise({required this.exercise, required this.score});
}
