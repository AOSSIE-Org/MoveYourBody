import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/widgets/home/search_bar.dart';

void main() {
  testWidgets('HomeSearchBar renders search icon and placeholder', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeSearchBar(),
        ),
      ),
    );

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('Search exercises or workouts'), findsOneWidget);
  });
}
