import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/onboarding/view/user_details.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(child: MaterialApp(home: UserdataScreen()));
  }

  group('UserdataScreen Widget Tests', () {
    testWidgets('renders all UI components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('A few details about you'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // 4 TextFields (Name, Weight, Height, Age)
      expect(find.byType(TextField), findsNWidgets(4));
    });

    testWidgets('can enter text in user detail fields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Let's enter text into the first text field (Name)
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(4));

      await tester.enterText(textFields.first, 'Vaibhav');
      await tester.pumpAndSettle();

      expect(find.text('Vaibhav'), findsOneWidget);
    });
  });
}
