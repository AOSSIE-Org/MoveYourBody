import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:move_your_body/features/home/widgets/home/disclaimer_dialog.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(home: Scaffold(body: DisclaimerDialog()));
  }

  group('DisclaimerDialog Widget Tests', () {
    testWidgets('renders all dialog UI components properly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Important Precautions'), findsOneWidget);
      expect(find.text('AI-Generated Workout Disclaimer'), findsOneWidget);
      expect(find.text('Voice Control Precaution'), findsOneWidget);
      expect(find.text('General Fitness Disclaimer'), findsOneWidget);
      expect(
        find.text(
          'I acknowledge I have read and understood these precautions.',
        ),
        findsOneWidget,
      );
      expect(find.text('Continue'), findsOneWidget);

      final checkboxFinder = find.byType(Checkbox);
      expect(checkboxFinder, findsOneWidget);
      final Checkbox checkbox = tester.widget(checkboxFinder);
      expect(checkbox.value, isFalse);

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Continue');
      final ElevatedButton button = tester.widget(buttonFinder);
      expect(button.onPressed, isNull);
    });

    testWidgets(
      'checking the box enables Continue button and tapping saves preference and pops',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => const DisclaimerDialog(),
                  ),
                  child: const Text('Open Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open Dialog'));
        await tester.pumpAndSettle();

        expect(find.byType(DisclaimerDialog), findsOneWidget);

        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        final Checkbox checkbox = tester.widget(find.byType(Checkbox));
        expect(checkbox.value, isTrue);

        final ElevatedButton button = tester.widget(
          find.widgetWithText(ElevatedButton, 'Continue'),
        );
        expect(button.onPressed, isNotNull);

        await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
        await tester.pumpAndSettle();

        expect(find.byType(DisclaimerDialog), findsNothing);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('disclaimer_accepted'), isTrue);
      },
    );

    testWidgets('showIfNeeded shows dialog when not accepted', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({'disclaimer_accepted': false});

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => DisclaimerDialog.showIfNeeded(context),
                child: const Text('Trigger'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(find.byType(DisclaimerDialog), findsOneWidget);
    });

    testWidgets('showIfNeeded does not show dialog when already accepted', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({'disclaimer_accepted': true});

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => DisclaimerDialog.showIfNeeded(context),
                child: const Text('Trigger'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(find.byType(DisclaimerDialog), findsNothing);
    });
  });
}