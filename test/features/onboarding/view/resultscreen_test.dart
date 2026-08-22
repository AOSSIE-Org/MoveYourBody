import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/onboarding/view/resultscreen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(child: MaterialApp(home: ResultScreen()));
  }

  group('ResultScreen Widget Tests', () {
    testWidgets('renders all UI components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // 1. Title
      expect(find.text('Collected Onboarding Data'), findsOneWidget);

      // 2. Default state should have "Not Provided" or empty values for fields since it's initial state
      // At least 12 fields are rendered
      expect(find.byType(Card), findsNWidgets(12));

      // Check for specific labels
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Target Body Region'), findsOneWidget);
    });
  });
}
