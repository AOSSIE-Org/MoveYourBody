import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/home/quick_plan_card.dart';

void main() {
  testWidgets('QuickPlanCard renders title and handles loading state', (WidgetTester tester) async {
    const testTitle = 'Fat Burn Blast';
    const testImagePath = 'assets/images/fat_burn_blast.png';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuickPlanCard(
            title: testTitle,
            imagePath: testImagePath,
            isLoading: false,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text(testTitle), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuickPlanCard(
            title: testTitle,
            imagePath: testImagePath,
            isLoading: true,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
