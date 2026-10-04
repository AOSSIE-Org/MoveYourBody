import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/exercise_info/section_card.dart';

void main() {
  testWidgets('SectionCard renders title and child correctly', (WidgetTester tester) async {
    const testTitle = 'Instructions';
    const childText = 'Do it carefully.';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionCard(
            title: testTitle,
            child: Text(childText),
          ),
        ),
      ),
    );

    expect(find.text(testTitle), findsOneWidget);
    expect(find.text(childText), findsOneWidget);
  });
}
