import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/ui/home/view_models/session_execution_view_model.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_tts'),
          (MethodCall methodCall) async => 1,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('com.llfbandit.record/messages'),
          (MethodCall methodCall) async => null,
        );
  });

  group('SessionExecutionViewModel', () {
    test('initializes correctly with session id', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(sessionExecutionViewModelProvider(1)),
        returnsNormally,
      );
    });
  });
}
