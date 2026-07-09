import 'package:sqflite/sqflite.dart';
import 'package:template_flutter/core/database/tables/user_table.dart';

class UserDatabaseService {
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${UserTable.tableName}(
        ${UserTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${UserTable.username} TEXT,
        ${UserTable.height} REAL,
        ${UserTable.weight} REAL,
        ${UserTable.age} INTEGER,
        ${UserTable.goalTags} TEXT,
        ${UserTable.customGoal} TEXT,
        ${UserTable.healthIssueTags} TEXT,
        ${UserTable.customHealthIssue} TEXT,
        ${UserTable.difficulty} TEXT,
        ${UserTable.intensity} TEXT,
        ${UserTable.targetBodyRegion} TEXT,
        ${UserTable.equipments} TEXT,
        ${UserTable.isOnboarded} INTEGER NOT NULL
      )
    ''');
  }
}
