import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/ui/onboarding/widgets/welcome_screen.dart';
import 'package:move_your_body/ui/common/feature_chip.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(home: WelcomeScreen());
  }

  group('WelcomeScreen Widget Tests', () {
    testWidgets('renders all UI components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining('Fitness Mentor'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(FeatureChip), findsNWidgets(4));
    });
  });
}
