import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/home/repositories/exercise_repository.dart';
import 'package:move_your_body/features/home/services/equipment_filter_service.dart';
import 'package:move_your_body/features/home/services/recommendation_service.dart';
import 'package:move_your_body/features/home/services/safety_filter_service.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/user_data.dart';

class MockExerciseRepository extends Mock implements ExerciseRepository {}
class MockSafetyFilterService extends Mock implements SafetyFilterService {}
class MockEquipmentFilterService extends Mock implements EquipmentFilterService {}
class MockUserData extends Mock implements UserData {}
class MockExercise extends Mock implements Exercise {}

void main() {
  group('RecommendationService', () {
    late RecommendationService service;
    late MockExerciseRepository mockExerciseRepo;
    late MockSafetyFilterService mockSafetyFilter;
    late MockEquipmentFilterService mockEquipmentFilter;

    setUp(() {
      mockExerciseRepo = MockExerciseRepository();
      mockSafetyFilter = MockSafetyFilterService();
      mockEquipmentFilter = MockEquipmentFilterService();

      service = RecommendationService(
        mockExerciseRepo,
        mockSafetyFilter,
        mockEquipmentFilter,
      );
    });

    test('recommends top 3 exercises based on user goals, regions, difficulty and intensity', () async {
      final user = MockUserData();
      when(() => user.goalTags).thenReturn(['fat_loss']);
      when(() => user.targetBodyRegion).thenReturn(['fullBody']);
      when(() => user.difficulty).thenReturn('beginner');
      when(() => user.intensity).thenReturn('low');

      final ex1 = MockExercise();
      when(() => ex1.exerciseId).thenReturn('ex1');
      when(() => ex1.goalTags).thenReturn(['fat_loss']);
      when(() => ex1.bodyRegions).thenReturn([BodyRegion.fullBody]);
      when(() => ex1.difficulty).thenReturn(Difficulty.beginner);
      when(() => ex1.intensity).thenReturn(Intensity.low);

      final ex2 = MockExercise();
      when(() => ex2.exerciseId).thenReturn('ex2');
      when(() => ex2.goalTags).thenReturn(['muscle_gain']);
      when(() => ex2.bodyRegions).thenReturn([BodyRegion.upperBody]);
      when(() => ex2.difficulty).thenReturn(Difficulty.advanced);
      when(() => ex2.intensity).thenReturn(Intensity.high);

      final ex3 = MockExercise();
      when(() => ex3.exerciseId).thenReturn('ex3');
      when(() => ex3.goalTags).thenReturn(['fat_loss']);
      when(() => ex3.bodyRegions).thenReturn([]);
      when(() => ex3.difficulty).thenReturn(Difficulty.beginner);
      when(() => ex3.intensity).thenReturn(Intensity.low);

      final ex4 = MockExercise();
      when(() => ex4.exerciseId).thenReturn('ex4');
      when(() => ex4.goalTags).thenReturn([]);
      when(() => ex4.bodyRegions).thenReturn([BodyRegion.fullBody]);
      when(() => ex4.difficulty).thenReturn(Difficulty.intermediate);
      when(() => ex4.intensity).thenReturn(Intensity.moderate);

      final allExercises = [ex1, ex2, ex3, ex4];

      when(() => mockExerciseRepo.getAllExercises()).thenAnswer((_) async => allExercises);
      when(() => mockSafetyFilter.filterExercises(
            exercises: allExercises,
            user: user,
            recentExerciseIds: [],
          )).thenReturn(allExercises);
      when(() => mockEquipmentFilter.filterExercises(
            exercises: allExercises,
            user: user,
          )).thenReturn(allExercises);

      final recommended = await service.recommendExercises(user, []);

      expect(recommended.length, 3);
      expect(recommended[0].exerciseId, 'ex1');
      expect(recommended[1].exerciseId, 'ex3');
      expect(recommended.contains(ex2), isFalse);
    });
  });
}
