import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/repositories/exercise_repository.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/package_info'),
      (MethodCall methodCall) async => {
        'appName': 'Test',
        'packageName': 'test',
        'version': '1.0',
        'buildNumber': '1',
      },
    );
  });

  group('ExerciseRepository', () {
    late ExerciseRepository repo;

    setUp(() {
      repo = ExerciseRepository();
    });

    test('getAllExercises returns a List<Exercise>', () async {
      final result = await repo.getAllExercises();
      expect(result, isA<List<Exercise>>());
    });

    test('getExercisesByIds returns empty list for empty input', () async {
      final result = await repo.getExercisesByIds([]);
      expect(result, isEmpty);
    });
  });
}
