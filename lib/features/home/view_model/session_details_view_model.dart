import 'package:move_your_body/features/home/repositories/exercise_repository.dart';
import 'package:move_your_body/features/home/repositories/session_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/session_details_state.dart';

part 'generated/session_details_view_model.g.dart';

@riverpod
class SessionDetailsViewModel extends _$SessionDetailsViewModel {
  @override
  SessionDetailsState build(int sessionId) {
    Future.microtask(() => loadSession());
    return const SessionDetailsState();
  }

  Future<void> loadSession() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final sessionRepo = ref.read(sessionRepositoryProvider);
      final session = await sessionRepo.getSessionById(sessionId);

      if (session == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No active session found.',
        );
        return;
      }

      final exerciseRepo = ref.read(exerciseRepositoryProvider);
      final exerciseIds =
          session.exercises.map((e) => e.exerciseId).toList();
      final exercises = await exerciseRepo.getExercisesByIds(exerciseIds);

      final defaultDurations = <String, int>{
        for (final exercise in exercises)
          exercise.exerciseId: 30,
      };

      state = state.copyWith(
        session: session,
        exercises: exercises,
        exerciseDurations: defaultDurations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void updateExerciseDuration(String exerciseId, int seconds) {
    if (seconds < 1) return;
    final updated = Map<String, int>.from(state.exerciseDurations);
    updated[exerciseId] = seconds;
    state = state.copyWith(exerciseDurations: updated);
  }

  void updatePreparationTime(int seconds) {
    if (seconds < 0) return;
    state = state.copyWith(preparationTime: seconds);
  }

  void updateRestTime(int seconds) {
    if (seconds < 0) return;
    state = state.copyWith(restTime: seconds);
  }
}
