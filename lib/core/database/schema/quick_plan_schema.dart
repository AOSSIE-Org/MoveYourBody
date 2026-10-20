import 'package:sqflite/sqflite.dart';
import 'package:move_your_body/core/database/tables/quick_plan_table.dart';

class QuickPlanDatabaseService {
  static Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${QuickPlanTable.tableName}(
        ${QuickPlanTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${QuickPlanTable.name} TEXT NOT NULL,
        ${QuickPlanTable.description} TEXT,
        ${QuickPlanTable.imagePath} TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${QuickPlanExercisesTable.tableName}(
        ${QuickPlanExercisesTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${QuickPlanExercisesTable.planId} INTEGER NOT NULL,
        ${QuickPlanExercisesTable.exerciseId} TEXT NOT NULL,
        ${QuickPlanExercisesTable.orderIndex} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (${QuickPlanExercisesTable.planId}) REFERENCES ${QuickPlanTable.tableName}(${QuickPlanTable.id})
      )
    ''');
  }
}
