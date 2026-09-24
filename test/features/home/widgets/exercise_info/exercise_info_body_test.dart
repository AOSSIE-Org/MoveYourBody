import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/home/widgets/exercise_info/exercise_info_body.dart';
import 'package:move_your_body/core/model/exercise_data.dart';

class MockExercise extends Mock implements Exercise {}

void main() {
  testWidgets('ExerciseInfoBody renders correctly with exercise data', (WidgetTester tester) async {
    final mockExercise = MockExercise();
    when(() => mockExercise.name).thenReturn('Jumping Jacks');
    when(() => mockExercise.overview).thenReturn('A great full body warmup.');
    when(() => mockExercise.difficulty).thenReturn(Difficulty.beginner);
    when(() => mockExercise.type).thenReturn(ExerciseType.cardio);
    when(() => mockExercise.intensity).thenReturn(Intensity.moderate);
    when(() => mockExercise.estimatedTime).thenReturn(60);
    when(() => mockExercise.primaryMuscles).thenReturn(['calves', 'shoulders']);
    when(() => mockExercise.secondaryMuscles).thenReturn(['core']);
    when(() => mockExercise.instructions).thenReturn('Stand tall and jump.');
    when(() => mockExercise.benefits).thenReturn('Burns calories effectively.');
    when(() => mockExercise.contraindications).thenReturn(['Knee injury']);
    when(() => mockExercise.equipments).thenReturn([]);
    when(() => mockExercise.bodyRegions).thenReturn([BodyRegion.fullBody]);
    when(() => mockExercise.goalTags).thenReturn(['Fat Burn']);
    when(() => mockExercise.movementPattern).thenReturn('Cardio');
    when(() => mockExercise.isLottie).thenReturn(false);
    when(() => mockExercise.animationLink).thenReturn('');
    when(() => mockExercise.exerciseId).thenReturn('ex1');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ExerciseInfoBody(exercise: mockExercise),
        ),
      ),
    );

    expect(find.text('Jumping Jacks'), findsWidgets);
    
    expect(find.text('A great full body warmup.'), findsOneWidget);

    expect(find.textContaining('Stand tall'), findsOneWidget);

    expect(find.textContaining('Burns calories'), findsOneWidget);
  });
}
