import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/onboarding/view/body_region_screen.dart';
import 'package:move_your_body/core/widgets/button_card.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(child: MaterialApp(home: BodyRegionScreen()));
  }

  group('BodyRegionScreen Widget Tests', () {
    testWidgets('renders all UI components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // 1. Text checks
      expect(
        find.text('What would you like to focus on most?'),
        findsOneWidget,
      );
      expect(find.text('Continue'), findsOneWidget);

      // 2. Element checks (5 ButtonCards expected)
      expect(find.byType(ButtonCard), findsNWidgets(5));
      expect(find.text('Cardio and Endurance'), findsOneWidget);
      expect(find.text('Upper Body'), findsOneWidget);

      // 3. Icon check (Back button)
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('can tap on a ButtonCard without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final targetCard = find.widgetWithText(ButtonCard, 'Upper Body');
      expect(targetCard, findsOneWidget);

      await tester.tap(targetCard);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
