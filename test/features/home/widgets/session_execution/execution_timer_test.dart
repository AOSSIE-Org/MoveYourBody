import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/session_execution/execution_timer.dart';

void main() {
  testWidgets('ExecutionTimer renders remaining time correctly', (WidgetTester tester) async {
    const remainingSeconds = 65; 

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExecutionTimer(
            remainingSeconds: remainingSeconds,
          ),
        ),
      ),
    );

    expect(find.text('1:05'), findsOneWidget);
  });
}
