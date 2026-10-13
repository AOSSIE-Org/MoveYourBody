import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/core/widgets/feature_chip.dart';

void main() {
  group('FeatureChip Widget Tests', () {
    testWidgets('renders text and responds to tap', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeatureChip(
              text: 'Cardio',
              selected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Cardio'), findsOneWidget);

      await tester.tap(find.text('Cardio'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('renders properly with selected true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FeatureChip(text: 'Strength', selected: true)),
        ),
      );

      expect(find.text('Strength'), findsOneWidget);
    });
  });
}
