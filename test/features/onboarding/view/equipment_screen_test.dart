import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/onboarding/view/equipment_screen.dart';
import 'package:move_your_body/core/widgets/button_card.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(child: MaterialApp(home: EquipmentScreen()));
  }

  group('EquipmentScreen Widget Tests', () {
    testWidgets('renders all UI components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(
        find.text('What equipment do you have access to?'),
        findsOneWidget,
      );
      expect(find.text('Continue'), findsOneWidget);

      // 6 Equipment options
      expect(find.byType(ButtonCard), findsNWidgets(6));
      expect(find.text('Yoga Mat'), findsOneWidget);
      expect(find.text('Dumbbells'), findsOneWidget);
    });

    testWidgets('can tap on equipment option without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final targetCard = find.widgetWithText(ButtonCard, 'Dumbbells');
      expect(targetCard, findsOneWidget);

      await tester.tap(targetCard);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
