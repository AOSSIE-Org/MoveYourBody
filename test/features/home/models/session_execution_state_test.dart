import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/models/session_execution_state.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/session_data.dart';

void main() {
  group('SessionExecutionState', () {
    final dummySession = Session(
      id: 1,
      createdAt: DateTime.utc(2024, 1, 1),
      sessionStatus: SessionStatus.created,
      exercises: [],
    );
    final dummyExercises = <Exercise>[];
    final dummyDurations = <String, int>{};

    test('constructs with required fields and defaults', () {
      final state = SessionExecutionState(
        session: dummySession,
        exercises: dummyExercises,
        exerciseDurations: dummyDurations,
        preparationTime: 5,
        restTime: 20,
      );
      expect(state.currentPhase, ExecutionPhase.preparation);
      expect(state.isPaused, false);
      expect(state.isInitializing, true);
    });

    test('value equality', () {
      final a = SessionExecutionState(
        session: dummySession,
        exercises: dummyExercises,
        exerciseDurations: dummyDurations,
        preparationTime: 5,
        restTime: 20,
      );
      final b = SessionExecutionState(
        session: dummySession,
        exercises: dummyExercises,
        exerciseDurations: dummyDurations,
        preparationTime: 5,
        restTime: 20,
      );
      expect(a, equals(b));
    });

    test('copyWith changes fields', () {
      final original = SessionExecutionState(
        session: dummySession,
        exercises: dummyExercises,
        exerciseDurations: dummyDurations,
        preparationTime: 5,
        restTime: 20,
      );
      final edited = original.copyWith(currentPhase: ExecutionPhase.workout, isPaused: true);
      expect(edited.currentPhase, ExecutionPhase.workout);
      expect(edited.isPaused, true);
      expect(edited, isNot(equals(original)));
    });
  });
}
