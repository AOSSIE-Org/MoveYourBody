import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:move_your_body/core/model/quick_plan_data.dart';
import 'package:move_your_body/features/home/repositories/quick_plan_repository.dart';

part 'generated/custom_plans_view_model.g.dart';

@riverpod
class CustomPlansViewModel extends _$CustomPlansViewModel {
  @override
  FutureOr<List<QuickPlan>> build() async {
    return _fetchCustomPlans();
  }

  Future<List<QuickPlan>> _fetchCustomPlans() async {
    final repo = ref.read(quickPlanRepositoryProvider);
    return await repo.fetchCustomPlans();
  }
  
  Future<void> refreshPlans() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCustomPlans());
  }
}
