import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/session_execution/phase_indicator.dart';
import 'package:move_your_body/features/home/models/session_execution_state.dart';

void main() {
  group('PhaseIndicator', () {
    Widget createTestWidget(ExecutionPhase phase) {
      return MaterialApp(
        home: Scaffold(
          body: PhaseIndicator(phase: phase),
        ),
      );
    }

    testWidgets('renders GET READY for preparation phase', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(ExecutionPhase.preparation));
      expect(find.text('GET READY'), findsOneWidget);
    });

    testWidgets('renders WORKOUT for workout phase', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(ExecutionPhase.workout));
      expect(find.text('WORKOUT'), findsOneWidget);
    });

    testWidgets('renders REST for rest phase', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(ExecutionPhase.rest));
      expect(find.text('REST'), findsOneWidget);
    });

    testWidgets('renders FINISHED for finished phase', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(ExecutionPhase.finished));
      expect(find.text('FINISHED'), findsOneWidget);
    });
  });
}
