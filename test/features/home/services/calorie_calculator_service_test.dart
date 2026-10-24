import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/utils/calorie_calculator.dart';
import 'package:move_your_body/domain/models/exercise_data.dart';

class MockExercise extends Mock implements Exercise {}

void main() {
  group('CalorieCalculator', () {
    test('returns 0.0 if weight or duration is zero or less', () {
      final exercise = MockExercise();

      expect(
        CalorieCalculator.calculateCaloriesBurned(
          exercise: exercise,
          userWeightKg: 0,
          durationInSeconds: 60,
        ),
        0.0,
      );

      expect(
        CalorieCalculator.calculateCaloriesBurned(
          exercise: exercise,
          userWeightKg: 70,
          durationInSeconds: -10,
        ),
        0.0,
      );
    });

    test('calculates correct calories for cardio with high intensity', () {
      final exercise = MockExercise();
      when(() => exercise.type).thenReturn(ExerciseType.cardio);
      when(() => exercise.intensity).thenReturn(Intensity.high);

      final result = CalorieCalculator.calculateCaloriesBurned(
        exercise: exercise,
        userWeightKg: 70,
        durationInSeconds: 3600,
      );

      expect(result, closeTo(7.0 * 1.2 * 70 * 1.0, 0.01));
    });

    test('calculates correct calories for yoga with low intensity', () {
      final exercise = MockExercise();
      when(() => exercise.type).thenReturn(ExerciseType.yoga);
      when(() => exercise.intensity).thenReturn(Intensity.low);

      final result = CalorieCalculator.calculateCaloriesBurned(
        exercise: exercise,
        userWeightKg: 50,
        durationInSeconds: 1800,
      );

      expect(result, closeTo(3.0 * 0.8 * 50 * 0.5, 0.01));
    });
  });
}
