import 'package:template_flutter/features/onboarding/model/onboarding_state.dart';

import '../database/tables/user_table.dart';

class UserData {
  final String username;
  final double height;
  final double weight;
  final int age;

  final List<String> goalTags;
  final String customGoal;

  final List<String> healthIssueTags;
  final String customHealthIssue;

  final String difficulty;
  final String intensity;

  final List<String> targetBodyRegion;
  final List<String> equipments;
  final bool isOnboarded;
  const UserData({
    required this.username,
    required this.height,
    required this.weight,
    required this.age,
    required this.goalTags,
    required this.customGoal,
    required this.healthIssueTags,
    required this.customHealthIssue,
    required this.difficulty,
    required this.intensity,
    required this.targetBodyRegion,
    required this.equipments,
    required this.isOnboarded,
  });

  Map<String, dynamic> toMap() {
    return {
      UserTable.username: username,
      UserTable.height: height,
      UserTable.weight: weight,
      UserTable.age: age,

      UserTable.goalTags: goalTags.join(','),
      UserTable.customGoal: customGoal,

      UserTable.healthIssueTags: healthIssueTags.join(','),
      UserTable.customHealthIssue: customHealthIssue,

      UserTable.difficulty: difficulty,
      UserTable.intensity: intensity,

      UserTable.targetBodyRegion: targetBodyRegion.join(','),
      UserTable.equipments: equipments.join(','),
      UserTable.isOnboarded: isOnboarded ? 1 : 0,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      username: map[UserTable.username] ?? '',
      height: map[UserTable.height] ?? 0,
      weight: map[UserTable.weight] ?? 0,
      age: map[UserTable.age] ?? 0,

      goalTags: (map[UserTable.goalTags] as String).split(','),

      customGoal: map[UserTable.customGoal] ?? '',

      healthIssueTags: (map[UserTable.healthIssueTags] as String).split(','),

      customHealthIssue: map[UserTable.customHealthIssue] ?? '',

      difficulty: map[UserTable.difficulty] ?? '',

      intensity: map[UserTable.intensity] ?? '',

      targetBodyRegion: (map[UserTable.targetBodyRegion] as String).split(','),

      equipments: (map[UserTable.equipments] as String).split(','),

      isOnboarded: map[UserTable.isOnboarded] == 1,
    );
  }
}

extension UserDataMapper on OnboardingState {
  UserData toUserdata() {
    return UserData(
      username: username ?? '',
      height: height ?? 0,
      weight: weight ?? 0,
      age: age ?? 0,
      goalTags: goalTags.toList(),
      customGoal: customGoal,
      healthIssueTags: healthIssueTags.toList(),
      customHealthIssue: customHealthIssue,
      difficulty: difficulty ?? '',
      intensity: intensity ?? '',
      targetBodyRegion: targetbodyRegion.toList(),
      equipments: equipments.toList(),
      isOnboarded: true,
    );
  }
}
