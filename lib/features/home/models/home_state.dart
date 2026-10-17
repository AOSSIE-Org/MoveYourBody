import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:move_your_body/core/model/exercise_data.dart';

part 'generated/home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    required DateTime selectedDate,
    required List<DateTime> currentWeekDays,
    @Default([]) List<Exercise> recommendedExercises,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _HomeState;
}
