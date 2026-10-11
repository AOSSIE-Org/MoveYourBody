import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/home/view_model/session_details_view_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('SessionDetailsViewModel', () {
    test('initializes correctly with session id', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(() => container.read(sessionDetailsViewModelProvider(1)), returnsNormally);
    });
  });
}
