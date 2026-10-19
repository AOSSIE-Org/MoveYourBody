import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/user_repository.dart';
import '../../../domain/models/user_data.dart';

part 'generated/onboarding_view_model.g.dart';

@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  @override
  UserData build() {
    return ref.watch(userRepositoryProvider).getUserData();
  }

  void _updateState(UserData userData) {
    ref.read(userRepositoryProvider).updateUserData(userData);
    state = userData;
  }

  void toggleGoal(String goal) {
    final updatedGoals = Set<String>.from(state.goalTags);
    if (updatedGoals.contains(goal)) {
      updatedGoals.remove(goal);
    } else {
      updatedGoals.add(goal);
    }

    _updateState(state.copyWith(goalTags: updatedGoals));
  }

  void updateCustomGoal(String goals) {
    _updateState(state.copyWith(customGoal: goals));
  }

  void toggleHealthIssue(String issue) {
    final updatedIssues = Set<String>.from(state.healthIssueTags);
    if (updatedIssues.contains(issue)) {
      updatedIssues.remove(issue);
    } else {
      updatedIssues.add(issue);
    }
    _updateState(state.copyWith(healthIssueTags: updatedIssues));
  }

  void updateCustomHealthIssue(String healthIssue) {
    _updateState(state.copyWith(customHealthIssue: healthIssue));
  }

  void setDifficulty(String difficulty) {
    _updateState(state.copyWith(difficulty: difficulty));
  }

  void setIntensity(String intensity) {
    _updateState(state.copyWith(intensity: intensity));
  }

  void toggleTargetBodyRegion(String region) {
    final updatedRegions = Set<String>.from(state.targetBodyRegion);
    if (updatedRegions.contains(region)) {
      updatedRegions.remove(region);
    } else {
      updatedRegions.add(region);
    }
    _updateState(state.copyWith(targetBodyRegion: updatedRegions));
  }

  void toggleEquipment(String equipment) {
    final updatedEquipments = Set<String>.from(state.equipments);
    if (updatedEquipments.contains(equipment)) {
      updatedEquipments.remove(equipment);
    } else {
      updatedEquipments.add(equipment);
    }
    _updateState(state.copyWith(equipments: updatedEquipments));
  }

  void setUsername(String username) {
    _updateState(state.copyWith(username: username));
  }

  void setAge(int age) {
    _updateState(state.copyWith(age: age));
  }

  void setWeight(double weight) {
    _updateState(state.copyWith(weight: weight));
  }

  void setHeight(double height) {
    _updateState(state.copyWith(height: height));
  }
}
