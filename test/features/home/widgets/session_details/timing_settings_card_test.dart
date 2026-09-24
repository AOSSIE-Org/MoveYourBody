import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/session_details/timing_settings_card.dart';

void main() {
  group('TimingSettingsCard', () {
    testWidgets('renders labels and initial values correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimingSettingsCard(
              preparationTime: 10,
              restTime: 20,
              onPreparationTimeChanged: (_) {},
              onRestTimeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Timing Settings'), findsOneWidget);
      expect(find.text('Preparation Time'), findsOneWidget);
      expect(find.text('Rest Time'), findsOneWidget);

      expect(find.text('10'), findsOneWidget); 
      expect(find.text('20'), findsOneWidget);
      expect(find.text('sec'), findsNWidgets(2)); 
    });

    testWidgets('calls onPreparationTimeChanged when buttons are tapped', (WidgetTester tester) async {
      int? updatedPrepTime;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimingSettingsCard(
              preparationTime: 10,
              restTime: 20,
              onPreparationTimeChanged: (val) => updatedPrepTime = val,
              onRestTimeChanged: (_) {},
            ),
          ),
        ),
      );
      final addIcons = find.byIcon(Icons.add);
      final removeIcons = find.byIcon(Icons.remove);
      await tester.tap(addIcons.first);
      expect(updatedPrepTime, 15);
      updatedPrepTime = null;
      await tester.tap(removeIcons.first);
      expect(updatedPrepTime, 5);
    });

    testWidgets('calls onRestTimeChanged when buttons are tapped', (WidgetTester tester) async {
      int? updatedRestTime;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimingSettingsCard(
              preparationTime: 10,
              restTime: 20,
              onPreparationTimeChanged: (_) {},
              onRestTimeChanged: (val) => updatedRestTime = val,
            ),
          ),
        ),
      );
      final addIcons = find.byIcon(Icons.add);
      final removeIcons = find.byIcon(Icons.remove);
      await tester.tap(addIcons.last);
      expect(updatedRestTime, 25);
      updatedRestTime = null;
      await tester.tap(removeIcons.last);
      expect(updatedRestTime, 15);
    });

    testWidgets('updates values when typed manually in TextField', (WidgetTester tester) async {
      int? updatedPrepTime;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimingSettingsCard(
              preparationTime: 10,
              restTime: 20,
              onPreparationTimeChanged: (val) => updatedPrepTime = val,
              onRestTimeChanged: (_) {},
            ),
          ),
        ),
      );

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
      await tester.enterText(textFields.first, '45');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      
      expect(updatedPrepTime, 45);
    });

    testWidgets('does not decrement below 0', (WidgetTester tester) async {
      int? updatedRestTime;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimingSettingsCard(
              preparationTime: 10,
              restTime: 0,
              onPreparationTimeChanged: (_) {},
              onRestTimeChanged: (val) => updatedRestTime = val,
            ),
          ),
        ),
      );

      final removeIcons = find.byIcon(Icons.remove);
      await tester.tap(removeIcons.last);
      expect(updatedRestTime, isNull);
    });
  });
}
