import 'package:move_your_body/features/onboarding/repository/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:move_your_body/features/home/services/recommendation_service.dart';
import '../models/home_state.dart';

part 'generated/home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    final now = DateTime.now();
    final currentWeekday = now.weekday;
    final firstDayOfWeek = now.subtract(Duration(days: currentWeekday % 7));

    final days = List.generate(
      7,
      (index) => firstDayOfWeek.add(Duration(days: index)),
    );

    Future.microtask(() => fetchRecommendations());

    return HomeState(selectedDate: now, currentWeekDays: days);
  }

  Future<void> fetchRecommendations() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final userRepo = ref.read(
        userRepositoryProvider,
      );
      final userData = await userRepo.getUserData();

      if (userData == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "User onboarding data not found.",
        );
        return;
      }

      final service = ref.read(recommendationServiceProvider);
      final exercises = await service.recommendExercises(userData);

      state = state.copyWith(recommendedExercises: exercises, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
