import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/core/widgets/app_scaffold.dart';

void main() {
  group('AppScaffold Widget Tests', () {
    testWidgets('renders child widget inside scaffold', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: AppScaffold(child: Text('Main Content'))),
      );

      expect(find.text('Main Content'), findsOneWidget);
    });

    testWidgets('renders bottomNavigationBar when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold(
            bottomNavigationBar: Text('Bottom Nav'),
            child: Text('Main Content'),
          ),
        ),
      );

      expect(find.text('Main Content'), findsOneWidget);
      expect(find.text('Bottom Nav'), findsOneWidget);
    });
  });
}
