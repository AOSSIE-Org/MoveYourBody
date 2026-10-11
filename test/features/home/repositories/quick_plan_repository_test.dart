import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/home/repositories/quick_plan_repository.dart';
import 'package:move_your_body/core/model/quick_plan_data.dart';
import 'package:move_your_body/features/onboarding/repository/user_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('QuickPlanRepository', () {
    late QuickPlanRepository repo;
    late MockUserRepository mockUserRepository;

    setUp(() {
      mockUserRepository = MockUserRepository();
      repo = QuickPlanRepository(userRepository: mockUserRepository);
    });

    test('fetchAllPlans returns a List<QuickPlan>', () async {
      final result = await repo.fetchAllPlans();
      expect(result, isA<List<QuickPlan>>());
    });
  });
}
