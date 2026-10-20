import 'dart:io';
import 'package:flutter/services.dart';
import 'package:move_your_body/core/database/schema/exercise_schema.dart';
import 'package:move_your_body/core/database/schema/quick_plan_schema.dart';
import 'package:move_your_body/core/database/schema/session_exercises_schema.dart';
import 'package:move_your_body/core/database/schema/session_schedule_schema.dart';
import 'package:move_your_body/core/database/schema/tags_schema.dart';
import 'package:move_your_body/core/database/schema/user_schema.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();

  DatabaseService._internal();

  Database? _database;
  Database? _exercisesDatabase;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> get userDatabase => database;

  Future<Database> get exercisesDatabase async {
    if (_exercisesDatabase != null) return _exercisesDatabase!;

    _exercisesDatabase = await _initExercisesDatabase();
    return _exercisesDatabase!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'move_your_body.db');
    debugPrint('DB PATH: $path');
    return openDatabase(
      path,
      version: 7,
      onCreate: (db, version) async {
        await UserDatabaseService.createTable(db);
        await ExerciseDatabaseService.createTable(db);
        await TagsDatabaseService.createTable(db);
        await SessionScheduleDatabaseService.createTable(db);
        await SessionExercisesDatabaseService.createTable(db);
        await QuickPlanDatabaseService.createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await ExerciseDatabaseService.createTable(db);
        }
        if (oldVersion < 3) {
          await TagsDatabaseService.createTable(db);
        }
        if (oldVersion < 4) {
          await SessionExercisesDatabaseService.createTable(db);
        }
        if (oldVersion < 5) {
          await QuickPlanDatabaseService.createTables(db);
          await db.execute(
            'ALTER TABLE session_schedule ADD COLUMN is_quick_plan INTEGER NOT NULL DEFAULT 0',
          );
        }
        if (oldVersion < 6) {
          await db.execute(
            'ALTER TABLE session_schedule ADD COLUMN quick_plan_id INTEGER',
          );
        }
        if (oldVersion < 7) {
          await db.execute(
            'ALTER TABLE quick_plans ADD COLUMN image_path TEXT',
          );
        }
      },
    );
  }

  Future<Database> _initExercisesDatabase() async {
    final basePath = await getDatabasesPath();
    final dbPath = join(basePath, 'exercises.db');

    await _copyExercisesDatabaseIfNeeded(dbPath);

    debugPrint('EXERCISES DB PATH: $dbPath');

    return openDatabase(
      dbPath,
      readOnly: true,
    );
  }

  Future<void> _copyExercisesDatabaseIfNeeded(String dbPath) async {
    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();

    final currentAppVersion = packageInfo.version;
    final copiedVersion = prefs.getString('exercise_userdatabase_version');

    final dbFile = File(dbPath);

    final shouldCopy =
        !await dbFile.exists() || copiedVersion != currentAppVersion;

    if (!shouldCopy) {
      debugPrint('Exercises database already up to date.');
      return;
    }

    debugPrint(
      'New version detected: $currentAppVersion (was $copiedVersion). Copying exercises DB...',
    );

    if (await dbFile.exists()) {
      await dbFile.delete();
    }

    final data = await rootBundle.load(
      'assets/exercises.db',
    );

    final bytes = data.buffer.asUint8List();

    await dbFile.writeAsBytes(
      bytes,
      flush: true,
    );

    await prefs.setString(
      'exercise_userdatabase_version',
      currentAppVersion,
    );

    debugPrint(
      'Exercises database copied for app version $currentAppVersion',
    );
  }
}
