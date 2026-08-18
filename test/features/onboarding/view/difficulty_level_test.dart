import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/onboarding/view/difficulty_level.dart';
import 'package:move_your_body/core/widgets/button_card.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(child: MaterialApp(home: DifficultyScreen()));
  }

  group('DifficultyScreen Widget Tests', () {
    testWidgets('renders all UI components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Choose your Difficulty Level'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // 3 Difficulty options
      expect(find.byType(ButtonCard), findsNWidgets(3));
      expect(find.text('Beginner'), findsOneWidget);
      expect(find.text('Intermediate'), findsOneWidget);
      expect(find.text('Advanced'), findsOneWidget);
    });

    testWidgets('can tap on difficulty option without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final targetCard = find.widgetWithText(ButtonCard, 'Beginner');
      expect(targetCard, findsOneWidget);

      await tester.tap(targetCard);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
