import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/ui/onboarding/widgets/resultscreen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(child: MaterialApp(home: ResultScreen()));
  }

  group('ResultScreen Widget Tests', () {
    testWidgets('renders all UI components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Profile'), findsOneWidget);

      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Weight'), findsOneWidget);
      expect(find.text('Height'), findsOneWidget);

      expect(find.text('Fitness Goals'), findsOneWidget);
      expect(find.text('Health Profile'), findsOneWidget);
      expect(find.text('Workout Preferences'), findsOneWidget);
      expect(find.text('Target Body Regions'), findsOneWidget);
      expect(find.text('Available Equipment'), findsOneWidget);
    });
  });
}
