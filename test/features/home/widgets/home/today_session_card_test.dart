import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/ui/home/widgets/home/today_session_card.dart';
import 'package:move_your_body/ui/home/view_models/home_view_model.dart';
import 'package:move_your_body/domain/models/home_state.dart';
import 'package:move_your_body/domain/models/exercise_data.dart';
import 'dart:async';
import 'package:move_your_body/domain/models/enums/exercise_enums.dart';

class MockExercise extends Mock implements Exercise {}

class FakeHomeViewModel extends HomeViewModel {
  final AsyncValue<HomeState> initialAsync;

  FakeHomeViewModel(this.initialAsync);

  @override
  Future<HomeState> build() async {
    if (initialAsync is AsyncError) {
      state = initialAsync;
      return Completer<HomeState>().future;
    }
    return initialAsync.when(
      data: (data) => data,
      error: (e, st) => throw e,
      loading: () => Completer<HomeState>().future,
    );
  }
}

void main() {
  Widget createTestWidget(AsyncValue<HomeState> state) {
    return ProviderScope(
      overrides: [
        homeViewModelProvider.overrideWith(() => FakeHomeViewModel(state)),
      ],
      child: const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: TodaySessionCard())),
      ),
    );
  }

  group('TodaySessionCard', () {
    testWidgets('shows loading indicator when loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(const AsyncLoading()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when there is an error', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(AsyncError('Error', StackTrace.current)),
      );
      await tester.pump();

      expect(find.text('Error loading recommendations'), findsOneWidget);
    });

    testWidgets('shows empty state when no exercises are available', (
      WidgetTester tester,
    ) async {
      final state = HomeState(
        selectedDate: DateTime.now(),
        currentWeekDays: [],
        recommendedExercises: [],
      );

      await tester.pumpWidget(createTestWidget(AsyncData(state)));
      await tester.pump();

      expect(
        find.text("No exercises available for today's session."),
        findsOneWidget,
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isFalse);
    });

    testWidgets('shows exercises and start button for new session', (
      WidgetTester tester,
    ) async {
      final mockEx = MockExercise();
      when(() => mockEx.name).thenReturn('Squats');
      when(() => mockEx.difficulty).thenReturn(Difficulty.intermediate);

      final state = HomeState(
        selectedDate: DateTime.now(),
        currentWeekDays: [],
        recommendedExercises: [mockEx],
        hasIncompleteSession: false,
      );

      await tester.pumpWidget(createTestWidget(AsyncData(state)));
      await tester.pump();

      expect(find.text('Squats'), findsOneWidget);
      expect(find.text('INTERMEDIATE'), findsOneWidget);
      expect(find.text('Start Session'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isTrue);
    });

    testWidgets('shows resume button for incomplete session', (
      WidgetTester tester,
    ) async {
      final mockEx = MockExercise();
      when(() => mockEx.name).thenReturn('Pushups');
      when(() => mockEx.difficulty).thenReturn(Difficulty.beginner);

      final state = HomeState(
        selectedDate: DateTime.now(),
        currentWeekDays: [],
        recommendedExercises: [mockEx],
        hasIncompleteSession: true,
      );

      await tester.pumpWidget(createTestWidget(AsyncData(state)));
      await tester.pump();

      expect(find.text('Pushups'), findsOneWidget);
      expect(find.text('Resume Session'), findsOneWidget);
    });
  });
}
