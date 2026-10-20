import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/home/session_summary_card.dart';

void main() {
  testWidgets('SessionSummaryCard renders time and burn values correctly', (WidgetTester tester) async {
    const testTime = '45 Min';
    const testBurn = '320 kcal';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SessionSummaryCard(
            time: testTime,
            burn: testBurn,
          ),
        ),
      ),
    );

    expect(find.text('Time'), findsOneWidget);
    expect(find.text(testTime), findsOneWidget);
    expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
    expect(find.text('Burn'), findsOneWidget);
    expect(find.text(testBurn), findsOneWidget);
    expect(find.byIcon(Icons.local_fire_department_outlined), findsOneWidget);
  });
}
