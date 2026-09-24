import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:move_your_body/features/onboarding/repository/user_repository.dart';
import 'package:move_your_body/core/model/user_data.dart';

void main() {
  late UserRepository userRepository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    userRepository = UserRepository();
  });

  tearDown(() async {
    await userRepository.deleteUserData();
  });

  group('UserRepository Tests', () {
    final testUser = UserData(
      username: 'Vaibhav',
      height: 175,
      weight: 70,
      age: 25,
      goalTags: ['fat_burn'],
      customGoal: '',
      healthIssueTags: ['knee_pain'],
      customHealthIssue: '',
      difficulty: 'Beginner',
      intensity: 'Light',
      targetBodyRegion: ['core'],
      equipments: ['yoga_mat'],
      isOnboarded: true,
      goalEmbeddings: null,
      healthIssueEmbeddings: null,
    );

    test('saveUser and getUserData should work correctly', () async {
      var fetchedUser = await userRepository.getUserData();
      expect(fetchedUser, isNull);

      await userRepository.saveUser(testUser);

      fetchedUser = await userRepository.getUserData();
      expect(fetchedUser, isNotNull);
      expect(fetchedUser!.username, 'Vaibhav');
      expect(fetchedUser.age, 25);
      expect(fetchedUser.goalTags, contains('fat_burn'));
    });

    test(
      'updateDifficultyAndIntensity should update values in database',
      () async {
        await userRepository.saveUser(testUser);

        await userRepository.updateDifficultyAndIntensity('Advanced', 'High');

        final updatedUser = await userRepository.getUserData();
        expect(updatedUser, isNotNull);
        expect(updatedUser!.difficulty, 'Advanced');
        expect(updatedUser.intensity, 'High');

        expect(updatedUser.username, 'Vaibhav');
      },
    );

    test('deleteUserData should remove the user from database', () async {
      await userRepository.saveUser(testUser);

      var fetchedUser = await userRepository.getUserData();
      expect(fetchedUser, isNotNull);

      await userRepository.deleteUserData();

      fetchedUser = await userRepository.getUserData();
      expect(fetchedUser, isNull);
    });
  });
}
