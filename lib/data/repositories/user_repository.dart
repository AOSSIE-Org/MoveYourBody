import 'package:flutter/cupertino.dart';
import 'package:move_your_body/data/database/tables/user_table.dart';
import 'package:move_your_body/domain/models/user_data.dart';
import 'package:move_your_body/data/database/db_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/user_repository.g.dart';

@Riverpod(keepAlive: true)
class UserRepository extends _$UserRepository {
  final DatabaseService? _customDbService;

  UserRepository([this._customDbService]);

  DatabaseService get _dbService =>
      _customDbService ?? ref.read(databaseServiceProvider);

  @override
  Future<UserData?> build() async {
    return _fetchFromDb();
  }

  Future<UserData?> _fetchFromDb() async {
    final result = await _dbService.queryUserDb(UserTable.tableName);
    if (result.isEmpty) return null;
    return UserData.fromMap(result.first);
  }

  Future<void> saveUser(UserData user) async {
    final existing = await _dbService.queryUserDb(
      UserTable.tableName,
      limit: 1,
    );
    if (existing.isNotEmpty) {
      final id = existing.first[UserTable.id];
      await _dbService.updateUserDb(
        UserTable.tableName,
        user.toMap(),
        where: '${UserTable.id} = ?',
        whereArgs: [id],
      );
    } else {
      await _dbService.insertUserDb(UserTable.tableName, {
        ...user.toMap(),
        UserTable.id: 1,
      });
    }
    try {
      state = AsyncData(user);
    } catch (_) {}
  }

  Future<UserData?> getUserData() async {
    try {
      final current = state.asData?.value;
      if (current != null) return current;
    } catch (_) {}
    return await _fetchFromDb();
  }

  Future<void> updateDifficultyAndIntensity(
    String newDifficulty,
    String newIntensity,
  ) async {
    await _dbService.updateUserDb(UserTable.tableName, {
      UserTable.difficulty: newDifficulty,
      UserTable.intensity: newIntensity,
    });
    try {
      final current = state.asData?.value;
      if (current != null) {
        state = AsyncData(
          current.copyWith(difficulty: newDifficulty, intensity: newIntensity),
        );
      }
    } catch (_) {}
  }

  Future<void> deleteUserData() async {
    String? username;
    try {
      username = state.asData?.value?.username;
    } catch (_) {}
    if (username != null) {
      await _dbService.deleteUserDb(
        UserTable.tableName,
        where: '${UserTable.username} = ?',
        whereArgs: [username],
      );
    } else {
      await _dbService.deleteUserDb(UserTable.tableName);
    }
    try {
      state = const AsyncData(null);
    } catch (_) {}
    debugPrint('User data deleted successfully');
  }
}
