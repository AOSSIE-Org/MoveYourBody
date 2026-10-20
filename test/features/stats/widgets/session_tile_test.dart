import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/stats/widgets/session_tile.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/core/routing/app_routes.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockGoRouter = MockGoRouter();
  });

  Widget createWidgetUnderTest(Session session) {
    return MaterialApp(
      home: Scaffold(
        body: InheritedGoRouter(
          goRouter: mockGoRouter,
          child: SessionTile(session: session),
        ),
      ),
    );
  }

  testWidgets('SessionTile renders correctly and navigates on tap', (
    WidgetTester tester,
  ) async {
    when(() => mockGoRouter.push(any())).thenAnswer((_) async => null);

    final dummySession = Session(
      id: 42,
      createdAt: DateTime.now(),
      sessionStatus: SessionStatus.completed,
      sessionDuration: 130,
      caloriesBurned: 150,
    );

    await tester.pumpWidget(createWidgetUnderTest(dummySession));

    expect(find.text('Workout Session'), findsOneWidget);
    expect(find.text('02:10'), findsOneWidget);
    expect(find.text('150.0 kcal'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    await tester.tap(find.byType(SessionTile));
    await tester.pumpAndSettle();

    verify(
      () => mockGoRouter.push(AppRoutes.pastSessionDetailsPath(42)),
    ).called(1);
  });
}
