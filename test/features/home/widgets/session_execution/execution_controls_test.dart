import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/home/widgets/session_execution/execution_controls.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('ExecutionControls renders play/pause, next, and time buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ExecutionControls(
              sessionId: 1,
            ),
          ),
        ),
      ),
    );
    expect(find.byType(ExecutionControls), findsOneWidget);
    expect(find.text('+10s'), findsOneWidget);
    expect(find.byIcon(Icons.fast_forward), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => w is Icon && (w.icon == Icons.play_arrow_rounded || w.icon == Icons.pause_rounded)),
      findsOneWidget,
    );
  });
}
