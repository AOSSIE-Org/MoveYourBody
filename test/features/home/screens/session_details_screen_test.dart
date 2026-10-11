import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/home/screens/session_details_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('SessionDetailsScreen builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SessionDetailsScreen(sessionId: 1),
        ),
      ),
    );

    expect(find.byType(SessionDetailsScreen), findsOneWidget);
  });
}
