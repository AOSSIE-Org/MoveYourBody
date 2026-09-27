import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/onboarding/view/health_issues.dart';
import 'package:move_your_body/core/widgets/feature_chip.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(child: MaterialApp(home: HealthIssuesScreen()));
  }

  group('HealthIssuesScreen Widget Tests', () {
    testWidgets('renders all UI components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Choose Your Health Issues'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // Expected 14 health issue chips
      expect(find.byType(FeatureChip), findsNWidgets(14));

      // TextField for custom issues
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('can tap on a FeatureChip without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final targetChip = find.widgetWithText(FeatureChip, 'Lower Back Pain');
      expect(targetChip, findsOneWidget);

      await tester.tap(targetChip);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
