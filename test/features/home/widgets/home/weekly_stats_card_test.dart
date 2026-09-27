import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/home/weekly_stats_card.dart';

void main() {
  testWidgets('WeeklyStatsCard renders all stats correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WeeklyStatsCard(),
        ),
      ),
    );

    expect(find.text('3 / 5'), findsOneWidget);
    expect(find.text('sessions'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('calories'), findsOneWidget);
    expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Day Streak'), findsOneWidget);
    expect(find.byIcon(Icons.bolt), findsOneWidget);
  });
}
