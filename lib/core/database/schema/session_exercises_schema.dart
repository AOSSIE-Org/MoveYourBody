import 'package:sqflite/sqflite.dart';
import 'package:move_your_body/core/database/tables/session_exercises_table.dart';

class SessionExercisesDatabaseService {
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${SessionExercisesTable.tableName}(
        ${SessionExercisesTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${SessionExercisesTable.sessionId} INTEGER NOT NULL,
        ${SessionExercisesTable.exerciseId} TEXT NOT NULL,
        ${SessionExercisesTable.orderIndex} INTEGER NOT NULL,
        ${SessionExercisesTable.liked} INTEGER,
        ${SessionExercisesTable.disliked} INTEGER,
        ${SessionExercisesTable.performedDuration} INTEGER,
        ${SessionExercisesTable.exerciseStatus} TEXT,
        ${SessionExercisesTable.completedAt} TEXT,
        FOREIGN KEY (${SessionExercisesTable.sessionId}) REFERENCES session_schedule(id) ON DELETE CASCADE
      )
    ''');
  }
}
