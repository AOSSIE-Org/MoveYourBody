import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/home/models/session_execution_state.dart';
import 'package:move_your_body/features/home/widgets/session_execution/execution_top_bar.dart';
import 'package:move_your_body/features/home/view_model/session_execution_view_model.dart';

class MockSessionExecutionState extends Mock implements SessionExecutionState {}

class MockSessionExecutionViewModel extends SessionExecutionViewModel {
  @override
  SessionExecutionState build(int sessionId) {
    return MockSessionExecutionState();
  }

  @override
  void pauseTimer() {}

  @override
  void resumeTimer() {}
}

void main() {
  group('ExecutionTopBar', () {
    late MockSessionExecutionViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockSessionExecutionViewModel();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          sessionExecutionViewModelProvider(1).overrideWith(() => mockViewModel),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ExecutionTopBar(
              sessionId: 1,
              currentIndex: 2,
              totalExercises: 10,
            ),
          ),
        ),
      );
    }

    testWidgets('renders progress text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Exercise 3 of 10'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('shows exit confirmation dialog on close tap', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('End Workout?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('End Session'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('End Workout?'), findsNothing);
    });
  });
}
