import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/stats/view_model/past_session_details_view_model.dart';
import 'package:move_your_body/features/home/repositories/session_repository.dart';
import 'package:move_your_body/features/home/repositories/exercise_repository.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/core/model/exercise_data.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

class MockExerciseRepository extends Mock implements ExerciseRepository {}

void main() {
  late MockSessionRepository mockSessionRepo;
  late MockExerciseRepository mockExerciseRepo;
  late ProviderContainer container;

  setUp(() {
    mockSessionRepo = MockSessionRepository();
    mockExerciseRepo = MockExerciseRepository();
    container = ProviderContainer(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(mockSessionRepo),
        exerciseRepositoryProvider.overrideWithValue(mockExerciseRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PastSessionDetailsViewModel Tests', () {
    test(
      'returns session with correctly mapped exercises on success',
      () async {
        final session = Session(
          id: 1,
          createdAt: DateTime.now(),
          sessionStatus: SessionStatus.completed,
          exercises: [
            const SessionExercise(
              sessionId: 1,
              exerciseId: 'ex1',
              orderIndex: 0,
              liked: false,
              performedDuration: 30,
              exerciseStatus: ExerciseStatus.completed,
            ),
            const SessionExercise(
              sessionId: 1,
              exerciseId: 'ex2',
              orderIndex: 1,
              liked: true,
              performedDuration: 45,
              exerciseStatus: ExerciseStatus.completed,
            ),
          ],
        );

        final exercises = [
          const Exercise(
            exerciseId: 'ex1',
            name: 'Push Ups',
            type: ExerciseType.strength,
            primaryMuscles: ['Chest'],
            secondaryMuscles: ['Triceps'],
            bodyRegions: [BodyRegion.upperBody],
            movementPattern: 'Push',
            difficulty: Difficulty.beginner,
            intensity: Intensity.moderate,
            goalTags: ['muscle_gain'],
            estimatedTime: 30,
            overview: 'A compound push exercise',
            benefits: 'Builds upper body strength',
            contraindications: [],
            instructions: 'Keep core tight',
            isLottie: false,
            equipments: [],
            animationLink: '',
          ),
          const Exercise(
            exerciseId: 'ex2',
            name: 'Squats',
            type: ExerciseType.strength,
            primaryMuscles: ['Quads'],
            secondaryMuscles: ['Glutes'],
            bodyRegions: [BodyRegion.lowerBody],
            movementPattern: 'Squat',
            difficulty: Difficulty.beginner,
            intensity: Intensity.moderate,
            goalTags: ['muscle_gain'],
            estimatedTime: 45,
            overview: 'A compound leg exercise',
            benefits: 'Builds lower body strength',
            contraindications: [],
            instructions: 'Keep knees behind toes',
            isLottie: false,
            equipments: [],
            animationLink: '',
          ),
        ];

        when(
          () => mockSessionRepo.getSessionById(1),
        ).thenAnswer((_) async => session);
        when(
          () => mockExerciseRepo.getExercisesByIds(['ex1', 'ex2']),
        ).thenAnswer((_) async => exercises);

        final result = await container.read(
          pastSessionDetailsProvider(1).future,
        );

        expect(result.session.id, 1);
        expect(result.session.sessionStatus, SessionStatus.completed);
        expect(result.exerciseDetails.length, 2);
        expect(result.exerciseDetails['ex1']?.name, 'Push Ups');
        expect(result.exerciseDetails['ex2']?.name, 'Squats');

        verify(() => mockSessionRepo.getSessionById(1)).called(1);
        verify(
          () => mockExerciseRepo.getExercisesByIds(['ex1', 'ex2']),
        ).called(1);
      },
    );

    test('returns empty exercise map when session has no exercises', () async {
      final session = Session(
        id: 5,
        createdAt: DateTime.now(),
        sessionStatus: SessionStatus.completed,
        exercises: [],
      );

      when(
        () => mockSessionRepo.getSessionById(5),
      ).thenAnswer((_) async => session);
      when(
        () => mockExerciseRepo.getExercisesByIds([]),
      ).thenAnswer((_) async => []);

      final result = await container.read(pastSessionDetailsProvider(5).future);

      expect(result.session.id, 5);
      expect(result.exerciseDetails, isEmpty);

      verify(() => mockSessionRepo.getSessionById(5)).called(1);
      verify(() => mockExerciseRepo.getExercisesByIds([])).called(1);
    });

    test('enters error state when session is not found (null)', () async {
      when(
        () => mockSessionRepo.getSessionById(99),
      ).thenAnswer((_) async => null);

      AsyncValue<PastSessionDetailsData>? latestValue;
      container.listen(pastSessionDetailsProvider(99), (prev, next) {
        latestValue = next;
      }, fireImmediately: true);

      await Future.delayed(const Duration(milliseconds: 200));

      expect(latestValue, isNotNull);
      expect(latestValue!.hasError, true);
      expect(latestValue!.error.toString(), contains('Session not found.'));

      verify(() => mockSessionRepo.getSessionById(99)).called(1);
      verifyNever(() => mockExerciseRepo.getExercisesByIds(any()));
    });
  });
}
