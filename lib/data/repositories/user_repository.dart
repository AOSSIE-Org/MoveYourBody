import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/data/database/tables/user_table.dart';
import 'package:move_your_body/domain/models/user_data.dart';
import 'package:move_your_body/data/database/db_config.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dbService = ref.read(databaseServiceProvider);
  return UserRepository(dbService);
});

class UserRepository {
  final DatabaseService _dbService;

  UserRepository([DatabaseService? dbService])
      : _dbService = dbService ?? DatabaseService.instance;

  Future<void> saveUser(UserData user) async {
    await _dbService.deleteUserDb(UserTable.tableName);
    await _dbService.insertUserRecord(user.toMap());
  }

  Future<UserData?> getUserData() async {
    debugPrint("Fetching user data from database...");
    final result = await _dbService.getUserRecords();

    if (result.isEmpty) {
      return null;
    }

    return UserData.fromMap(result.first);
  }

  Future<void> updateDifficultyAndIntensity(
    String newDifficulty,
    String newIntensity,
  ) async {
    await _dbService.updateUserDb(
      UserTable.tableName,
      {
        UserTable.difficulty: newDifficulty,
        UserTable.intensity: newIntensity,
      },
    );
  }

  Future<void> deleteUserData() async {
    final user = await getUserData();

    if (user == null) {
      debugPrint('No user data found to delete');
      return;
    }

    await _dbService.deleteUserRecord(user.username);

    debugPrint('User data deleted successfully');
  }

  Future<void> debugPrintUserData() async {
    final user = await getUserData();
    debugPrint('===================');
    debugPrint(user?.username.toString());
    debugPrint(user?.age.toString());
    debugPrint(user?.height.toString());
    debugPrint(user?.weight.toString());
    debugPrint(user?.goalTags.toString());
    debugPrint(user?.healthIssueTags.toString());
    debugPrint(user?.difficulty.toString());
    debugPrint(user?.intensity.toString());
    debugPrint(user?.targetBodyRegion.toString());
    debugPrint(user?.equipments.toString());
    debugPrint(user?.isOnboarded.toString());
    debugPrint(user?.healthIssueEmbeddings.toString());
    debugPrint(user?.goalEmbeddings.toString());
    debugPrint('===================');
  }
}
