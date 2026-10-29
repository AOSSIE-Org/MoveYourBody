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

  UserRepository(this._dbService);

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
    await _dbService.updateUserDb(UserTable.tableName, {
      UserTable.difficulty: newDifficulty,
      UserTable.intensity: newIntensity,
    });
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
}
