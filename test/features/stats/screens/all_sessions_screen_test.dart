import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/stats/screens/all_sessions_screen.dart';
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
      child: const MaterialApp(home: AllSessionsScreen()),
    );
  }

  testWidgets(
    'AllSessionsScreen displays Today for a session completed today',
    (WidgetTester tester) async {
      final dummySession = Session(
        id: 1,
        createdAt: DateTime.now(),
        sessionStatus: SessionStatus.completed,
        sessionDuration: 45,
        caloriesBurned: 200,
      );

      when(
        () => mockRepo.getAllSessions(),
      ).thenAnswer((_) async => [dummySession]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('All Sessions'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
    },
  );
}
