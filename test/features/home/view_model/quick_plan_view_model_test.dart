import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/home/repositories/quick_plan_repository.dart';
import 'package:move_your_body/features/home/view_model/quick_plan_view_model.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/core/model/quick_plan_data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockQuickPlanRepository extends Mock implements QuickPlanRepository {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('QuickPlanViewModel', () {
    late ProviderContainer container;
    late MockQuickPlanRepository mockRepo;

    setUp(() {
      mockRepo = MockQuickPlanRepository();
      container = ProviderContainer(
        overrides: [
          quickPlanRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
    });



    test('initializes plans correctly', () async {
      final plans = [
        const QuickPlan(
          id: 1,
          name: 'Plan 1',
          description: 'Desc 1',
        )
      ];

      when(() => mockRepo.seedPlansIfNeeded(force: true)).thenAnswer((_) async {});
      when(() => mockRepo.fetchAllPlans()).thenAnswer((_) async => plans);

      final initialState = container.read(quickPlanViewModelProvider);
      expect(initialState.isSeeding, isTrue);

      await Future.delayed(Duration.zero);

      final state = container.read(quickPlanViewModelProvider);
      expect(state.isSeeding, isFalse);
      expect(state.plans, plans);
    });

    test('onPlanTapped handles success', () async {
      when(() => mockRepo.seedPlansIfNeeded(force: true)).thenAnswer((_) async {});
      when(() => mockRepo.fetchAllPlans()).thenAnswer((_) async => []);

      final session = Session(
        id: 1,
        createdAt: DateTime.now(),
        sessionStatus: SessionStatus.created,
      );

      when(() => mockRepo.createSessionFromPlan(1)).thenAnswer((_) async => session);

      final viewModel = container.read(quickPlanViewModelProvider.notifier);
      
      final result = await viewModel.onPlanTapped(1);

      expect(result, session);
      final state = container.read(quickPlanViewModelProvider);
      expect(state.tapStatus, QuickPlanStatus.success);
    });

    test('onPlanTapped handles failure', () async {
      when(() => mockRepo.seedPlansIfNeeded(force: true)).thenAnswer((_) async {});
      when(() => mockRepo.fetchAllPlans()).thenAnswer((_) async => []);

      when(() => mockRepo.createSessionFromPlan(1)).thenAnswer((_) async => null);

      final viewModel = container.read(quickPlanViewModelProvider.notifier);
      
      final result = await viewModel.onPlanTapped(1);

      expect(result, isNull);
      final state = container.read(quickPlanViewModelProvider);
      expect(state.tapStatus, QuickPlanStatus.error);
      expect(state.errorMessage, isNotNull);
    });
  });
}
