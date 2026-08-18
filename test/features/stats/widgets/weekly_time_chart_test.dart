import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:move_your_body/features/stats/widgets/weekly_time_chart.dart';
import 'package:move_your_body/core/model/session_data.dart';

void main() {
  Widget createWidgetUnderTest(List<Session> sessions) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: WeeklyTimeChart(allSessions: sessions),
        ),
      ),
    );
  }

  testWidgets('WeeklyTimeChart renders BarChart and calculates duration', (
    WidgetTester tester,
  ) async {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final sessions = [
      Session(
        createdAt: startOfWeek,
        sessionStatus: SessionStatus.completed,
        sessionDuration: 1800,
      ),
      Session(
        createdAt: startOfWeek.add(const Duration(days: 2)),
        sessionStatus: SessionStatus.completed,
        sessionDuration: 3600,
      ),
      Session(
        createdAt: startOfWeek.add(
          const Duration(days: 2),
        ),
        sessionStatus: SessionStatus.inProgress,
        sessionDuration: 500,
      ),
    ];

    await tester.pumpWidget(createWidgetUnderTest(sessions));

    await tester.pumpAndSettle();

    expect(find.byType(BarChart), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('Time spent this week'),
      ),
      findsOneWidget,
    );
  });
}
