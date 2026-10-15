import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/database/tables/user_table.dart';
import 'package:move_your_body/core/model/user_data.dart';
import '../../../core/database/db_config.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  Future<void> saveUser(UserData user) async {
    final db = await DatabaseService.instance.database;
    await db.insert('user_data', user.toMap());
  }

  Future<UserData?> getUserData() async {
    final db = await DatabaseService.instance.database;
    debugPrint("Fetching user data from database...");
    final result = await db.query(UserTable.tableName, limit: 1);

    if (result.isEmpty) {
      return null;
    }

    return UserData.fromMap(result.first);
  }

  Future<void> deleteUserData() async {
    final user = await getUserData();

    if (user == null) {
      debugPrint('No user data found to delete');
      return;
    }

    final db = await DatabaseService.instance.database;

    await db.delete(UserTable.tableName);

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
    debugPrint('===================');
  }
}
