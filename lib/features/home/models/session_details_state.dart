import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/session_data.dart';

part 'generated/session_details_state.freezed.dart';

@freezed
abstract class SessionDetailsState with _$SessionDetailsState {
  const factory SessionDetailsState({
    Session? session,
    @Default([]) List<Exercise> exercises,
    @Default(true) bool isLoading,
    String? errorMessage,
    @Default({}) Map<String, int> exerciseDurations,
    @Default(5) int preparationTime,
    @Default(20) int restTime,
  }) = _SessionDetailsState;
}
