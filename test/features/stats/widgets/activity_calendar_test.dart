import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:move_your_body/features/stats/widgets/activity_calendar.dart';

void main() {
  Widget createWidgetUnderTest(List<DateTime> activeDates) {
    return MaterialApp(
      home: Scaffold(body: ActivityCalendar(activeDates: activeDates)),
    );
  }

  testWidgets(
    'ActivityCalendar displays TableCalendar and highlights active dates',
    (WidgetTester tester) async {
      final today = DateTime.now();
      final activeDates = [
        DateTime(today.year, today.month, today.day),
        DateTime(
          today.year,
          today.month,
          today.day,
        ).subtract(const Duration(days: 2)),
      ];

      await tester.pumpWidget(createWidgetUnderTest(activeDates));

      expect(find.byType(TableCalendar), findsOneWidget);

      expect(find.text('${today.day}'), findsWidgets);

      final pastDay = activeDates[1].day;
      expect(find.text('$pastDay'), findsWidgets);
    },
  );
}
