import 'package:move_your_body/features/home/repositories/exercise_repository.dart';
import 'package:move_your_body/features/home/repositories/session_repository.dart';
import 'package:move_your_body/features/onboarding/repository/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:move_your_body/features/home/services/recommendation_service.dart';
import 'package:move_your_body/core/model/session_data.dart';
import '../models/home_state.dart';

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
      final incompleteSession =
          await sessionRepo.getLatestIncompleteSession();

      if (incompleteSession != null) {
        final exerciseRepo = ref.read(exerciseRepositoryProvider);
        final exerciseIds =
            incompleteSession.exercises.map((e) => e.exerciseId).toList();
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
          errorMessage: "User onboarding data not found.",
        );
        return;
      }

      final service = ref.read(recommendationServiceProvider);
      final exercises = await service.recommendExercises(userData);

      state = state.copyWith(
        recommendedExercises: exercises,
        hasIncompleteSession: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
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
