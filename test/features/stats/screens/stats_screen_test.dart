import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/stats/screens/stats_screen.dart';
import 'package:move_your_body/features/home/repositories/session_repository.dart';
import 'package:move_your_body/core/model/session_data.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late MockSessionRepository mockRepo;

  setUp(() {
    mockRepo = MockSessionRepository();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [sessionRepositoryProvider.overrideWithValue(mockRepo)],
      child: const MaterialApp(home: StatsScreen()),
    );
  }

  testWidgets('StatsScreen shows empty state when there are no sessions', (
    WidgetTester tester,
  ) async {
    when(() => mockRepo.getAllSessions()).thenAnswer((_) async => []);

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pumpAndSettle();

    expect(find.text('Activity Review'), findsOneWidget);
    expect(
      find.text('No sessions completed yet. Time to move your body!'),
      findsOneWidget,
    );
  });

  testWidgets('StatsScreen shows recent sessions when data is available', (
    WidgetTester tester,
  ) async {
    final dummySession = Session(
      id: 1,
      createdAt: DateTime.now(),
      sessionStatus: SessionStatus.completed,
      sessionDuration: 60,
      caloriesBurned: 300,
    );

    when(
      () => mockRepo.getAllSessions(),
    ).thenAnswer((_) async => [dummySession]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Activity Review'), findsOneWidget);
    expect(find.text('Recent Sessions'), findsOneWidget);

    expect(
      find.text('No sessions completed yet. Time to move your body!'),
      findsNothing,
    );
  });
}
