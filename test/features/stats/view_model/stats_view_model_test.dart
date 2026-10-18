import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/stats/view_model/stats_view_model.dart';
import 'package:move_your_body/features/home/repositories/session_repository.dart';
import 'package:move_your_body/core/model/session_data.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late MockSessionRepository mockSessionRepo;
  late ProviderContainer container;

  setUp(() {
    mockSessionRepo = MockSessionRepository();
    container = ProviderContainer(
      overrides: [sessionRepositoryProvider.overrideWithValue(mockSessionRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('StatsViewModel Tests', () {
    test('initial build returns loading state with empty lists', () async {
      when(() => mockSessionRepo.getAllSessions()).thenAnswer((_) async => []);

      final sub = container.listen(statsViewModelProvider, (_, __) {});

      final initialState = sub.read();
      expect(initialState.isLoading, true);
      expect(initialState.activeDates, isEmpty);
      expect(initialState.allSessions, isEmpty);

      await Future.delayed(const Duration(milliseconds: 200));
    });

    test(
      'fetches sessions, filters active dates for completed only, and sorts descending',
      () async {
        final day1 = DateTime(2023, 10, 1);
        final day2 = DateTime(2023, 10, 2);
        final day3 = DateTime(2023, 10, 3);

        final dummySessions = [
          Session(
            id: 1,
            createdAt: day1,
            sessionStatus: SessionStatus.completed,
          ),
          Session(
            id: 2,
            createdAt: day2,
            sessionStatus: SessionStatus.inProgress,
          ),
          Session(
            id: 3,
            createdAt: day3,
            sessionStatus: SessionStatus.completed,
          ),
        ];

        when(
          () => mockSessionRepo.getAllSessions(),
        ).thenAnswer((_) async => dummySessions);

        final sub = container.listen(statsViewModelProvider, (_, __) {});
        await Future.delayed(const Duration(milliseconds: 200));

        final state = sub.read();

        expect(state.isLoading, false);
        expect(state.allSessions.length, 3);

        expect(state.allSessions[0].id, 3);
        expect(state.allSessions[1].id, 2);
        expect(state.allSessions[2].id, 1);

        expect(state.activeDates.length, 2);
        expect(state.activeDates.contains(day2), false);
      },
    );

    test('catches exception and sets empty non-loading state', () async {
      when(
        () => mockSessionRepo.getAllSessions(),
      ).thenThrow(Exception('DB crashed'));

      final sub = container.listen(statsViewModelProvider, (_, __) {});
      await Future.delayed(const Duration(milliseconds: 200));

      final state = sub.read();
      expect(state.isLoading, false);
      expect(state.allSessions, isEmpty);
      expect(state.activeDates, isEmpty);
    });

    test('handles empty sessions list from repository', () async {
      when(() => mockSessionRepo.getAllSessions()).thenAnswer((_) async => []);

      final sub = container.listen(statsViewModelProvider, (_, _) {});
      await Future.delayed(const Duration(milliseconds: 200));

      final state = sub.read();
      expect(state.isLoading, false);
      expect(state.allSessions, isEmpty);
      expect(state.activeDates, isEmpty);
    });

    test('activeDates is empty when all sessions are inProgress', () async {
      final sessions = [
        Session(
          id: 1,
          createdAt: DateTime(2023, 10, 1),
          sessionStatus: SessionStatus.inProgress,
        ),
        Session(
          id: 2,
          createdAt: DateTime(2023, 10, 2),
          sessionStatus: SessionStatus.inProgress,
        ),
      ];

      when(
        () => mockSessionRepo.getAllSessions(),
      ).thenAnswer((_) async => sessions);

      final sub = container.listen(statsViewModelProvider, (_, _) {});
      await Future.delayed(const Duration(milliseconds: 200));

      final state = sub.read();
      expect(state.isLoading, false);
      expect(state.allSessions.length, 2);
      expect(state.activeDates, isEmpty);
    });
  });
}
