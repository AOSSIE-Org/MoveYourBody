import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/onboarding_state.dart';

class OnboardingViewModel extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void toggleGoal(String goal) {
    final updatedGoals = Set<String>.from(state.goalTags);
    if (updatedGoals.contains(goal)) {
      updatedGoals.remove(goal);
    } else {
      updatedGoals.add(goal);
    }

    state = state.copyWith(goalTags: updatedGoals);
  }

  void updateCustomGoal(String goals) {
    state = state.copyWith(customGoal: goals);
  }

  void toggleHealthIssue(String issue) {
    final updatedIssues = Set<String>.from(state.healthIssueTags);
    if (updatedIssues.contains(issue)) {
      updatedIssues.remove(issue);
    } else {
      updatedIssues.add(issue);
    }
    state = state.copyWith(healthIssueTags: updatedIssues);
  }

  void updateCustomHealthIssue(String healthIssue) {
    state = state.copyWith(customHealthIssue: healthIssue);
  }

  void setDifficulty(String difficulty) {
    state = state.copyWith(difficulty: difficulty);
  }

  void setIntensity(String intensity) {
    state = state.copyWith(intensity: intensity);
  }

  void toggleTargetBodyRegion(String region) {
    final updatedRegions = Set<String>.from(state.targetbodyRegion);
    if (updatedRegions.contains(region)) {
      updatedRegions.remove(region);
    } else {
      updatedRegions.add(region);
    }
    state = state.copyWith(targetbodyRegion: updatedRegions);
  }

  void toggleEquipment(String equipment) {
    final updatedEquipments = Set<String>.from(state.equipments);
    if (updatedEquipments.contains(equipment)) {
      updatedEquipments.remove(equipment);
    } else {
      updatedEquipments.add(equipment);
    }
    state = state.copyWith(equipments: updatedEquipments);
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  void setWeight(double? weight) {
    state = state.copyWith(weight: weight);
  }

  void setHeight(double? height) {
    state = state.copyWith(height: height);
  }

  void setAge(int? age) {
    state = state.copyWith(age: age);
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingViewModel, OnboardingState>(
      OnboardingViewModel.new,
    );
