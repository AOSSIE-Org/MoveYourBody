import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/core/model/exercise_data.dart';

part 'generated/session_execution_state.freezed.dart';

enum ExecutionPhase {
  preparation,
  workout,
  rest,
  finished
}

enum DifficultyFeedback {
  easy,
  medium,
  hard
}

enum IntensityFeedback {
  light,
  medium,
  high
}

@freezed
abstract class SessionExecutionState with _$SessionExecutionState {
  const factory SessionExecutionState({
    required Session session,
    required List<Exercise> exercises,
    required Map<String, int> exerciseDurations,
    required int preparationTime,
    required int restTime,
    
    @Default(ExecutionPhase.preparation) ExecutionPhase currentPhase,
    @Default(0) int currentExerciseIndex,
    @Default(0) int remainingSeconds,
    @Default(false) bool isPaused,
    @Default(0) int totalElapsedSeconds,
    @Default(true) bool isInitializing,
    
    DifficultyFeedback? difficultyFeedback,
    IntensityFeedback? intensityFeedback,
  }) = _SessionExecutionState;
}
