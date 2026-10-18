import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/onboarding/model/onboarding_data.dart';

void main() {
  group('OnboardingData Model Tests', () {
    test('should create instance with default values', () {
      const data = OnboardingData();

      expect(data.goalTags, isEmpty);
      expect(data.customGoal, '');
      expect(data.healthIssueTags, isEmpty);
      expect(data.customHealthIssue, '');
      expect(data.difficulty, isNull);
      expect(data.intensity, isNull);
      expect(data.targetBodyRegion, isEmpty);
      expect(data.equipments, isEmpty);
      expect(data.username, isNull);
      expect(data.height, isNull);
      expect(data.weight, isNull);
      expect(data.age, isNull);
      expect(data.goalEmbeddings, isNull);
      expect(data.healthIssueEmbeddings, isNull);
    });

    test('should correctly use copyWith to update values', () {
      const initialData = OnboardingData();

      final updatedData = initialData.copyWith(
        username: 'Vaibhav',
        age: 25,
        goalTags: {'fat_burn', 'muscle_building'},
      );

      expect(updatedData.username, 'Vaibhav');
      expect(updatedData.age, 25);
      expect(updatedData.goalTags, contains('fat_burn'));
      expect(updatedData.goalTags.length, 2);

      expect(updatedData.customGoal, '');
      expect(updatedData.height, isNull);
    });
  });
}
