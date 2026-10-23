import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/ui/common/button_card.dart';

void main() {
  group('ButtonCard Widget Tests', () {
    testWidgets('renders title and subtitle and responds to tap', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonCard(
              title: 'Intermediate',
              subtitle: 'Consistent for 6 months',
              selected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Intermediate'), findsOneWidget);
      expect(find.text('Consistent for 6 months'), findsOneWidget);

      await tester.tap(find.text('Intermediate'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('renders properly when selected is true and subtitle is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonCard(title: 'Advanced', selected: true, onTap: () {}),
          ),
        ),
      );

      expect(find.text('Advanced'), findsOneWidget);
    });
  });
}
