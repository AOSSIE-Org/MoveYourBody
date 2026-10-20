import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/home/view_model/search_view_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('SearchViewModel', () {
    test('initializes correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(() => container.read(searchViewModelProvider), returnsNormally);
    });
  });
}
