import 'package:sqflite/sqflite.dart';
import 'package:move_your_body/core/database/tables/exercise_table.dart';

class ExerciseDatabaseService {
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${ExerciseTable.tableName}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ExerciseTable.exerciseId} TEXT UNIQUE,
        ${ExerciseTable.name} TEXT NOT NULL,
        ${ExerciseTable.type} TEXT NOT NULL,
        ${ExerciseTable.primaryMuscles} TEXT,
        ${ExerciseTable.secondaryMuscles} TEXT,
        ${ExerciseTable.bodyRegions} TEXT,
        ${ExerciseTable.movementPattern} TEXT,
        ${ExerciseTable.difficulty} TEXT,
        ${ExerciseTable.intensity} TEXT,
        ${ExerciseTable.goalTags} TEXT,
        ${ExerciseTable.estimatedTime} INTEGER,
        ${ExerciseTable.overview} TEXT,
        ${ExerciseTable.benefits} TEXT,
        ${ExerciseTable.contraindications} TEXT,
        ${ExerciseTable.instructions} TEXT,
        ${ExerciseTable.isLottie} INTEGER,
        ${ExerciseTable.equipments} TEXT,
        ${ExerciseTable.animationLink} TEXT
      )
    ''');
  }
}
