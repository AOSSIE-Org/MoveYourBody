import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:move_your_body/features/onboarding/view/splash_screen.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  Widget createWidgetUnderTest() {
    return const ProviderScope(child: MaterialApp(home: SplashScreen()));
  }

  group('SplashScreen Widget Tests', () {
    testWidgets('renders loading indicator correctly', (
      WidgetTester tester,
    ) async {
      // Pump widget but do not pumpAndSettle because it has a timer/async router call
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(SplashScreen), findsOneWidget);

      // The screen should display a CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
