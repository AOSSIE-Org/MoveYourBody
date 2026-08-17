import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/stats/screens/past_session_details_screen.dart';
import 'package:move_your_body/features/home/repositories/session_repository.dart';
import 'package:move_your_body/features/home/repositories/exercise_repository.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/core/model/exercise_data.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

class MockExerciseRepository extends Mock implements ExerciseRepository {}

void main() {
  late MockSessionRepository mockSessionRepo;
  late MockExerciseRepository mockExerciseRepo;

  setUp(() {
    mockSessionRepo = MockSessionRepository();
    mockExerciseRepo = MockExerciseRepository();
  });

  Widget createWidgetUnderTest(int sessionId) {
    return ProviderScope(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(mockSessionRepo),
        exerciseRepositoryProvider.overrideWithValue(mockExerciseRepo),
      ],
      child: MaterialApp(home: PastSessionDetailsScreen(sessionId: sessionId)),
    );
  }

  testWidgets('PastSessionDetailsScreen shows Workout Review and data', (
    WidgetTester tester,
  ) async {
    final session = Session(
      id: 1,
      createdAt: DateTime.now(),
      sessionStatus: SessionStatus.completed,
      sessionDuration: 90,
      caloriesBurned: 50,
      exercises: [
        const SessionExercise(
          sessionId: 1,
          exerciseId: 'ex1',
          orderIndex: 0,
          liked: true,
          performedDuration: 30,
          exerciseStatus: ExerciseStatus.completed,
        ),
      ],
    );

    final exercise = Exercise(
      exerciseId: 'ex1',
      name: 'Push Ups',
      type: ExerciseType.strength,
      primaryMuscles: ['Chest', 'Triceps'],
      secondaryMuscles: ['Shoulders'],
      bodyRegions: [BodyRegion.upperBody],
      movementPattern: 'Push',
      difficulty: Difficulty.beginner,
      intensity: Intensity.moderate,
      goalTags: ['muscle_gain'],
      estimatedTime: 30,
      overview: 'Push ups overview',
      benefits: 'Chest strength',
      contraindications: ['Wrist pain'],
      instructions: 'Do push ups',
      isLottie: false,
      equipments: [],
      animationLink: '',
    );

    when(
      () => mockSessionRepo.getSessionById(1),
    ).thenAnswer((_) async => session);
    when(
      () => mockExerciseRepo.getExercisesByIds(['ex1']),
    ).thenAnswer((_) async => [exercise]);

    await tester.pumpWidget(createWidgetUnderTest(1));
    await tester.pumpAndSettle();

    expect(find.text('Workout Review'), findsOneWidget);
    expect(find.text('COMPLETED'), findsWidgets);
    expect(find.text('Push Ups'), findsOneWidget);
  });
}
