import 'dart:io';
import 'package:flutter/services.dart';
import 'package:move_your_body/core/database/schema/exercise_schema.dart';
import 'package:move_your_body/core/database/schema/session_exercises_schema.dart';
import 'package:move_your_body/core/database/schema/session_schedule_schema.dart';
import 'package:move_your_body/core/database/schema/tags_schema.dart';
import 'package:move_your_body/core/database/schema/user_schema.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();

  DatabaseService._internal();

  Database? _userdatabase;
  Database? _exercisesDatabase;

  Future<Database> get userDatabase async {
    if (_userdatabase != null) return _userdatabase!;

    _userdatabase = await _initDatabase();
    return _userdatabase!;
  }

  Future<Database> get exercisesDatabase async {
    if (_exercisesDatabase != null) return _exercisesDatabase!;

    _exercisesDatabase = await _initExercisesDatabase();
    return _exercisesDatabase!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'move_your_body.db');
    debugPrint('DB PATH: $path');
    return openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await UserDatabaseService.createTable(db);
        await ExerciseDatabaseService.createTable(db);
        await TagsDatabaseService.createTable(db);
        await SessionScheduleDatabaseService.createTable(db);
        await SessionExercisesDatabaseService.createTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await ExerciseDatabaseService.createTable(db);
          await TagsDatabaseService.createTable(db);
        }
        if (oldVersion < 3) {
          await SessionScheduleDatabaseService.createTable(db);
        }
        if (oldVersion < 4) {
          await SessionExercisesDatabaseService.createTable(db);
        }
      },
    );
  }

  Future<Database> _initExercisesDatabase() async {
    final dbDirectory = await getDatabasesPath();
    final dbPath = join(dbDirectory, 'exercises.db');

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
    final copiedVersion =
        prefs.getString('exercise_userdatabase_version');

    final dbFile = File(dbPath);

    final shouldCopy =
        !await dbFile.exists() ||
        copiedVersion != currentAppVersion;

    if (!shouldCopy) {
      debugPrint('Exercises database already up to date.');
      return;
    }

    debugPrint('Copying exercises.db...');

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
