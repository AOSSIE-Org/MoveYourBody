import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/home/home_app_bar.dart';

void main() {
  testWidgets('HomeAppBar renders username correctly', (WidgetTester tester) async {
    const testUsername = 'Vaibhav';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeAppBar(username: testUsername),
        ),
      ),
    );

    expect(find.textContaining(testUsername), findsOneWidget);
    expect(find.text('Hi Champ 👋'), findsOneWidget);
  });
}
