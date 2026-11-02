import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/domain/models/user_data.dart';
import 'package:move_your_body/domain/models/onboarding_data.dart';

void main() {
  group('UserData Model Tests', () {
    final goalEmbeddings = Uint8List.fromList([1, 2, 3]);
    final healthEmbeddings = Uint8List.fromList([4, 5, 6]);

    final userData = UserData(
      username: 'Alex',
      height: 175.0,
      weight: 70.0,
      age: 25,
      goalTags: ['Muscle Gain', 'Endurance'],
      customGoal: 'Get fit',
      healthIssueTags: ['None'],
      customHealthIssue: '',
      difficulty: 'intermediate',
      intensity: 'high',
      targetBodyRegion: ['Full Body'],
      equipments: ['Dumbbells'],
      isOnboarded: true,
      goalEmbeddings: goalEmbeddings,
      healthIssueEmbeddings: healthEmbeddings,
    );

    test('toMap serializes UserData correctly', () {
      final map = userData.toMap();

      expect(map['username'], 'Alex');
      expect(map['height'], 175.0);
      expect(map['weight'], 70.0);
      expect(map['age'], 25);
      expect(map['goal_tags'], 'Muscle Gain,Endurance');
      expect(map['custom_goal'], 'Get fit');
      expect(map['difficulty'], 'intermediate');
      expect(map['intensity'], 'high');
      expect(map['is_onboarded'], 1);
      expect(map['goal_embeddings'], goalEmbeddings);
      expect(map['health_issue_embeddings'], healthEmbeddings);
    });

    test('fromMap deserializes map correctly', () {
      final map = userData.toMap();
      final parsed = UserData.fromMap(map);

      expect(parsed.username, 'Alex');
      expect(parsed.height, 175.0);
      expect(parsed.weight, 70.0);
      expect(parsed.age, 25);
      expect(parsed.goalTags, ['Muscle Gain', 'Endurance']);
      expect(parsed.isOnboarded, isTrue);
      expect(parsed.goalEmbeddings, goalEmbeddings);
    });

    test('UserDataMapper extension converts OnboardingData to UserData', () {
      final onboardingData = OnboardingData(
        username: 'Jordan',
        height: 180.0,
        weight: 75.0,
        age: 30,
        goalTags: {'Strength'},
        customGoal: 'Lift heavier',
        healthIssueTags: {'Knee'},
        customHealthIssue: 'Right knee pain',
        difficulty: 'beginner',
        intensity: 'low',
        targetBodyRegion: {'Legs'},
        equipments: {'Yoga Mat'},
        goalEmbeddings: goalEmbeddings,
        healthIssueEmbeddings: healthEmbeddings,
      );

      final converted = onboardingData.toUserdata();

      expect(converted.username, 'Jordan');
      expect(converted.height, 180.0);
      expect(converted.weight, 75.0);
      expect(converted.age, 30);
      expect(converted.goalTags, ['Strength']);
      expect(converted.customGoal, 'Lift heavier');
      expect(converted.isOnboarded, isTrue);
    });
  });
}
