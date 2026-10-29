import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:move_your_body/domain/models/exercise_data.dart';
import 'package:move_your_body/domain/models/session_data.dart';

part 'generated/home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    required DateTime selectedDate,
    required List<DateTime> currentWeekDays,
    @Default([]) List<Exercise> recommendedExercises,
    @Default(false) bool isLoading,
    @Default(false) bool isCreatingSession,
    Session? currentSession,
    @Default(false) bool hasIncompleteSession,
    String? errorMessage,
  }) = _HomeState;
}
