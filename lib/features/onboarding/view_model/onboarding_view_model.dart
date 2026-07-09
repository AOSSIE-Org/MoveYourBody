import 'dart:typed_data';
import 'package:move_your_body/features/onboarding/repository/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/onboarding_data.dart';
import "../../../core/model/user_data.dart";

part 'generated/onboarding_view_model.g.dart';

@Riverpod(keepAlive: true)
class OnboardingViewModel extends _$OnboardingViewModel {
  @override
  OnboardingData build() {
    return const OnboardingData();
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
    final updatedRegions = Set<String>.from(state.targetBodyRegion);
    if (updatedRegions.contains(region)) {
      updatedRegions.remove(region);
    } else {
      updatedRegions.add(region);
    }
    state = state.copyWith(targetBodyRegion: updatedRegions);
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

  void setAge(int age) {
    state = state.copyWith(age: age);
  }

  void setWeight(double weight) {
    state = state.copyWith(weight: weight);
  }

  void setHeight(double height) {
    state = state.copyWith(height: height);
  }

  void loadFromUserData(UserData user) {
    state = state.copyWith(
      username: user.username,
      age: user.age,
      height: user.height,
      weight: user.weight,
      goalTags: user.goalTags.toSet(),
      customGoal: user.customGoal,
      healthIssueTags: user.healthIssueTags.toSet(),
      customHealthIssue: user.customHealthIssue,
      difficulty: user.difficulty,
      intensity: user.intensity,
      targetBodyRegion: user.targetBodyRegion.toSet(),
      equipments: user.equipments.toSet(),
    );
  }

  Future<void> saveAndCompleteOnboarding({
    required Uint8List? goalEmbed,
    required Uint8List? healthEmbed,
  }) async {
    state = state.copyWith(
      goalEmbeddings: goalEmbed,
      healthIssueEmbeddings: healthEmbed,
    );
    final userData = state.toUserdata();
    await ref.read(userRepositoryProvider).saveUser(userData);
  }
}
