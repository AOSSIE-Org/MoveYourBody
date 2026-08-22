import 'package:move_your_body/core/model/quick_plan_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/features/home/repositories/quick_plan_repository.dart';

part 'generated/quick_plan_view_model.g.dart';

enum QuickPlanStatus { idle, loading, success, error }

class QuickPlanState {
  final bool isSeeding;
  final QuickPlanStatus tapStatus;
  final String? errorMessage;
  final int? tappedPlanId;
  final List<QuickPlan> plans;

  const QuickPlanState({
    this.isSeeding = false,
    this.tapStatus = QuickPlanStatus.idle,
    this.errorMessage,
    this.tappedPlanId,
    this.plans = const [],
  });

  QuickPlanState copyWith({
    bool? isSeeding,
    QuickPlanStatus? tapStatus,
    String? errorMessage,
    int? tappedPlanId,
    List<QuickPlan>? plans,
  }) {
    return QuickPlanState(
      isSeeding: isSeeding ?? this.isSeeding,
      tapStatus: tapStatus ?? this.tapStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      tappedPlanId: tappedPlanId ?? this.tappedPlanId,
      plans: plans ?? this.plans,
    );
  }
}

@Riverpod(keepAlive: true)
class QuickPlanViewModel extends _$QuickPlanViewModel {
  @override
  QuickPlanState build() {
    Future.microtask(() => _initializePlans());
    return const QuickPlanState(isSeeding: true);
  }

  Future<void> _initializePlans() async {
    final repo = ref.read(quickPlanRepositoryProvider);
    await repo.seedPlansIfNeeded(force: true);
    final plans = await repo.fetchAllPlans();
    state = state.copyWith(isSeeding: false, plans: plans);
  }

  Future<Session?> onPlanTapped(int planId) async {
    state = state.copyWith(
      tapStatus: QuickPlanStatus.loading,
      errorMessage: null,
      tappedPlanId: planId,
    );
    try {
      final repo = ref.read(quickPlanRepositoryProvider);
      final session = await repo.createSessionFromPlan(planId);

      if (session == null) {
        state = state.copyWith(
          tapStatus: QuickPlanStatus.error,
          errorMessage: 'Could not load plan. Please try again.',
        );
        return null;
      }

      state = state.copyWith(tapStatus: QuickPlanStatus.success);
      return session;
    } catch (e) {
      state = state.copyWith(
        tapStatus: QuickPlanStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  void resetTapStatus() {
    state = state.copyWith(
      tapStatus: QuickPlanStatus.idle,
      errorMessage: null,
    );
  }
}
