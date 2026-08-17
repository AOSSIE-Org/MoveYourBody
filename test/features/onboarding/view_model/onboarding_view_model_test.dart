import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/model/user_data.dart';
import 'package:move_your_body/features/onboarding/repository/user_repository.dart';
import 'package:move_your_body/features/onboarding/view_model/onboarding_view_model.dart';

class FakeUserRepository extends UserRepository {
  UserData? savedUser;

  @override
  Future<void> saveUser(UserData user) async {
    savedUser = user;
  }
}

void main() {
  group('OnboardingViewModel Tests', () {
    late ProviderContainer container;
    late FakeUserRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeUserRepository();
      container = ProviderContainer(
        overrides: [userRepositoryProvider.overrideWithValue(fakeRepository)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be empty OnboardingData', () {
      final state = container.read(onboardingViewModelProvider);

      expect(state.username, isNull);
      expect(state.goalTags, isEmpty);
    });

    test('toggleGoal should add and remove a goal correctly', () {
      final notifier = container.read(onboardingViewModelProvider.notifier);

      notifier.toggleGoal('fat_burn');
      expect(
        container.read(onboardingViewModelProvider).goalTags,
        contains('fat_burn'),
      );

      notifier.toggleGoal('muscle_building');
      expect(
        container.read(onboardingViewModelProvider).goalTags,
        containsAll(['fat_burn', 'muscle_building']),
      );

      notifier.toggleGoal('fat_burn');
      expect(
        container.read(onboardingViewModelProvider).goalTags,
        isNot(contains('fat_burn')),
      );
      expect(
        container.read(onboardingViewModelProvider).goalTags,
        contains('muscle_building'),
      );
    });

    test(
      'set user details (username, age, weight, height) should update state',
      () {
        final notifier = container.read(onboardingViewModelProvider.notifier);

        notifier.setUsername('Vaibhav');
        notifier.setAge(28);
        notifier.setWeight(75.5);
        notifier.setHeight(180.0);

        final state = container.read(onboardingViewModelProvider);
        expect(state.username, 'Vaibhav');
        expect(state.age, 28);
        expect(state.weight, 75.5);
        expect(state.height, 180.0);
      },
    );

    test('setDifficulty and setIntensity should update state', () {
      final notifier = container.read(onboardingViewModelProvider.notifier);

      notifier.setDifficulty('Advanced');
      notifier.setIntensity('High');

      final state = container.read(onboardingViewModelProvider);
      expect(state.difficulty, 'Advanced');
      expect(state.intensity, 'High');
    });

    test('loadFromUserData should correctly populate state from UserData', () {
      final dummyUser = UserData(
        username: 'John',
        height: 170,
        weight: 65,
        age: 30,
        goalTags: ['fat_burn'],
        customGoal: 'Marathon',
        healthIssueTags: ['knee_pain'],
        customHealthIssue: 'None',
        difficulty: 'Beginner',
        intensity: 'Low',
        targetBodyRegion: ['core'],
        equipments: ['dumbbells'],
        isOnboarded: true,
        goalEmbeddings: null,
        healthIssueEmbeddings: null,
      );

      final notifier = container.read(onboardingViewModelProvider.notifier);
      notifier.loadFromUserData(dummyUser);

      final state = container.read(onboardingViewModelProvider);
      expect(state.username, 'John');
      expect(state.age, 30);
      expect(state.goalTags, contains('fat_burn'));
      expect(state.customGoal, 'Marathon');
      expect(state.difficulty, 'Beginner');
    });

    test('saveAndCompleteOnboarding should call repository saveUser', () async {
      final notifier = container.read(onboardingViewModelProvider.notifier);

      notifier.setUsername('Rahul');

      await notifier.saveAndCompleteOnboarding(
        goalEmbed: Uint8List.fromList([1, 2, 3]),
        healthEmbed: Uint8List.fromList([4, 5, 6]),
      );

      expect(fakeRepository.savedUser, isNotNull);
      expect(fakeRepository.savedUser!.username, 'Rahul');
      expect(fakeRepository.savedUser!.goalEmbeddings, isNotNull);
    });
  });
}
