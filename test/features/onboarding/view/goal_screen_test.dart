import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/onboarding/view/goal_screen.dart';
import 'package:move_your_body/core/widgets/feature_chip.dart';
import 'package:move_your_body/core/routing/app_routes.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  Widget createWidgetWithRouter(NavigatorObserver observer) {
    final router = GoRouter(
      initialLocation: '/goal',
      observers: [observer],
      routes: [
        GoRoute(path: '/goal', builder: (context, state) => const GoalScreen()),
        GoRoute(
          path: AppRoutes.healthIssues,
          builder: (context, state) =>
              const Scaffold(body: Text('Health Issues Screen')),
        ),
      ],
    );

    return ProviderScope(child: MaterialApp.router(routerConfig: router));
  }

  group('GoalScreen Widget Tests with Navigation (Level-2)', () {
    testWidgets('renders all UI components correctly', (
      WidgetTester tester,
    ) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(createWidgetWithRouter(mockObserver));
      await tester.pumpAndSettle();

      expect(find.text('Choose Your Goals'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(FeatureChip), findsNWidgets(14));
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('can tap on a goal chip without crashing', (
      WidgetTester tester,
    ) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(createWidgetWithRouter(mockObserver));
      await tester.pumpAndSettle();

      final fatBurnChip = find.widgetWithText(FeatureChip, 'Burn Fat');
      expect(fatBurnChip, findsOneWidget);

      await tester.tap(fatBurnChip);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('tapping Continue button navigates to HealthIssues screen', (
      WidgetTester tester,
    ) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(createWidgetWithRouter(mockObserver));
      await tester.pumpAndSettle();

      final continueButton = find.text('Continue');
      expect(continueButton, findsOneWidget);

      await tester.tap(continueButton);

      await tester.pumpAndSettle();

      verify(
        () => mockObserver.didPush(any(), any()),
      ).called(greaterThanOrEqualTo(1));

      expect(find.text('Health Issues Screen'), findsOneWidget);
    });
  });
}
