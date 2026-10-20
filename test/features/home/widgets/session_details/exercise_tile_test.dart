import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/session_details/exercise_tile.dart';

void main() {
  group('ExerciseTile', () {
    testWidgets('renders title and initial duration correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseTile(
              title: 'Push Ups',
              durationSeconds: 30,
            ),
          ),
        ),
      );

      expect(find.text('Push Ups'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('sec'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
    });

    testWidgets('calls onInfoTap when info icon is tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseTile(
              title: 'Plank',
              durationSeconds: 60,
              onInfoTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.info_outline_rounded));
      expect(tapped, isTrue);
    });

    testWidgets('calls onDurationChanged when increment and decrement are tapped', (WidgetTester tester) async {
      int? changedDuration;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseTile(
              title: 'Squats',
              durationSeconds: 30,
              onDurationChanged: (val) => changedDuration = val,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      expect(changedDuration, 35);
      changedDuration = null;
      await tester.tap(find.byIcon(Icons.remove));
      expect(changedDuration, 25);
    });

    testWidgets('does not decrement below 5', (WidgetTester tester) async {
      int? changedDuration;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseTile(
              title: 'Squats',
              durationSeconds: 5,
              onDurationChanged: (val) => changedDuration = val,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      expect(changedDuration, isNull);
    });

    testWidgets('calls onDurationChanged when text is submitted manually', (WidgetTester tester) async {
      int? changedDuration;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseTile(
              title: 'Burpees',
              durationSeconds: 30,
              onDurationChanged: (val) => changedDuration = val,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '45');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      
      expect(changedDuration, 45);
    });
  });
}
