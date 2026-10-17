import 'package:sqflite/sqflite.dart';
import 'package:move_your_body/core/database/tables/session_schedule_table.dart';

class SessionScheduleDatabaseService {
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${SessionScheduleTable.tableName}(
        ${SessionScheduleTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${SessionScheduleTable.createdAt} TEXT NOT NULL,
        ${SessionScheduleTable.sessionDuration} INTEGER,
        ${SessionScheduleTable.sessionStatus} TEXT,
        ${SessionScheduleTable.difficultyFeedback} TEXT,
        ${SessionScheduleTable.intensityFeedback} TEXT,
        ${SessionScheduleTable.caloriesBurned} REAL
      )
    ''');
  }
}
