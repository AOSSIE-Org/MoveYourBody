import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/session_execution/exercise_name_display.dart';

void main() {
  group('ExerciseNameDisplay', () {
    testWidgets('renders current exercise name when not resting', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseNameDisplay(
              exerciseName: 'Jumping Jacks',
              isResting: false,
            ),
          ),
        ),
      );

      expect(find.text('Jumping Jacks'), findsOneWidget);
    });

    testWidgets('renders next exercise name when resting', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseNameDisplay(
              exerciseName: 'Jumping Jacks',
              isResting: true,
              nextExerciseName: 'Squats',
            ),
          ),
        ),
      );

      expect(find.text('Up Next: Squats'), findsOneWidget);
    });

    testWidgets('renders current exercise name when resting but no next exercise', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseNameDisplay(
              exerciseName: 'Session Complete',
              isResting: true,
              nextExerciseName: null,
            ),
          ),
        ),
      );

      expect(find.text('Session Complete'), findsOneWidget);
    });
  });
}
