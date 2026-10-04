import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/session_details/instructions_card.dart';

void main() {
  testWidgets('InstructionsCard renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: InstructionsCard(),
        ),
      ),
    );

    expect(find.text('Instructions:'), findsOneWidget);
    expect(find.text('Voice Controls'), findsOneWidget);
    expect(find.text('Pause - say to stop'), findsOneWidget);
    expect(find.text('Start - say to resume'), findsOneWidget);
    expect(find.text('Skip - to skip current exercise'), findsOneWidget);
    expect(find.text('Add time - +10 seconds'), findsOneWidget);
    expect(find.byIcon(Icons.pause), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.skip_next), findsOneWidget);
    expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
  });
}
