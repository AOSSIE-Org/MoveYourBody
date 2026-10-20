import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/home/services/safety_filter_service.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/user_data.dart';

class MockExercise extends Mock implements Exercise {}
class MockUserData extends Mock implements UserData {}

void main() {
  group('SafetyFilterService', () {
    late SafetyFilterService service;

    setUp(() {
      service = SafetyFilterService();
    });

    test('filters out exercises with contraindications matching user health issues', () {
      final user = MockUserData();
      when(() => user.healthIssueTags).thenReturn(['knee_pain']);

      final exSafe = MockExercise();
      when(() => exSafe.exerciseId).thenReturn('ex1');
      when(() => exSafe.contraindications).thenReturn(['shoulder_pain']);

      final exUnsafe = MockExercise();
      when(() => exUnsafe.exerciseId).thenReturn('ex2');
      when(() => exUnsafe.contraindications).thenReturn(['knee_pain']);

      final result = service.filterExercises(
        exercises: [exSafe, exUnsafe],
        user: user,
        recentExerciseIds: [],
      );

      expect(result.length, 1);
      expect(result.first.exerciseId, 'ex1');
    });

    test('skips anti-boredom filter if fresh exercises are too few', () {
      final user = MockUserData();
      when(() => user.healthIssueTags).thenReturn([]);

      final ex1 = MockExercise();
      when(() => ex1.exerciseId).thenReturn('ex1');
      when(() => ex1.contraindications).thenReturn([]);

      final ex2 = MockExercise();
      when(() => ex2.exerciseId).thenReturn('ex2');
      when(() => ex2.contraindications).thenReturn([]);

      final result = service.filterExercises(
        exercises: [ex1, ex2],
        user: user,
        recentExerciseIds: ['ex1'],
      );

      expect(result.length, 2);
    });

    test('applies anti-boredom filter when enough fresh exercises exist', () {
      final user = MockUserData();
      when(() => user.healthIssueTags).thenReturn([]);

      final exercises = List.generate(4, (index) {
        final ex = MockExercise();
        when(() => ex.exerciseId).thenReturn('ex$index');
        when(() => ex.contraindications).thenReturn([]);
        return ex;
      });

      final result = service.filterExercises(
        exercises: exercises,
        user: user,
        recentExerciseIds: ['ex0'],
      );

      expect(result.length, 3);
      expect(result.any((e) => e.exerciseId == 'ex0'), isFalse);
    });
  });
}
