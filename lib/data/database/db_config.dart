import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:move_your_body/data/database/schema/exercise_schema.dart';
import 'package:move_your_body/data/database/schema/quick_plan_schema.dart';
import 'package:move_your_body/data/database/schema/session_exercises_schema.dart';
import 'package:move_your_body/data/database/schema/session_schedule_schema.dart';
import 'package:move_your_body/data/database/schema/tags_schema.dart';
import 'package:move_your_body/data/database/schema/user_schema.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:move_your_body/utils/constants/app_constants.dart';

part 'generated/db_config.g.dart';

@Riverpod(keepAlive: true)
DatabaseService databaseService(Ref ref) {
  return DatabaseService();
}

class DatabaseService {
  late final Future<Database> _userDatabaseFuture;
  late final Future<Database> _exercisesDatabaseFuture;

  DatabaseService() {
    _userDatabaseFuture = _initUserDatabase();
    _exercisesDatabaseFuture = _initExercisesDatabase();
  }

  Future<Database> get userDatabase => _userDatabaseFuture;
  Future<Database> get exercisesDatabase => _exercisesDatabaseFuture;

  Future<List<Map<String, Object?>>> queryUserDb(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await userDatabase;
    return db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> insertUserDb(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await userDatabase;
    return db.insert(
      table,
      values,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  Future<int> updateUserDb(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await userDatabase;
    return db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  Future<int> deleteUserDb(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await userDatabase;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, Object?>>> rawQueryUserDb(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = await userDatabase;
    return db.rawQuery(sql, arguments);
  }

  Future<T> transactionUserDb<T>(
    Future<T> Function(Transaction txn) action, {
    bool? exclusive,
  }) async {
    final db = await userDatabase;
    return db.transaction(action, exclusive: exclusive);
  }

  Future<List<Map<String, Object?>>> queryExercisesDb(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await exercisesDatabase;
    return db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<List<Map<String, Object?>>> rawQueryExercisesDb(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = await exercisesDatabase;
    return db.rawQuery(sql, arguments);
  }

  Future<Database> _initUserDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'move_your_body.db');

    debugPrint('DB PATH: $path');

    return openDatabase(
      path,
      version: 8,
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
          await TagsDatabaseService.createTable(db);
        }
        if (oldVersion < 3) {
          await SessionScheduleDatabaseService.createTable(db);
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
            'ALTER TABLE user_data ADD COLUMN goal_embeddings BLOB',
          );
          await db.execute(
            'ALTER TABLE user_data ADD COLUMN health_issue_embeddings BLOB',
          );
        }
        if (oldVersion < 7) {
          await db.execute('ALTER TABLE session_schedule ADD COLUMN mood TEXT');
          await db.execute(
            'ALTER TABLE session_schedule ADD COLUMN notes TEXT',
          );
        }
        if (oldVersion < 8) {
          await db.execute(
            'ALTER TABLE session_schedule ADD COLUMN session_type TEXT',
          );
        }
      },
    );
  }

  Future<Database> _initExercisesDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, 'exercises.db');

    await _copyExercisesDatabaseIfNeeded(dbPath);

    debugPrint('EXERCISES DB PATH: $dbPath');

    return openDatabase(dbPath, readOnly: true);
  }

  Future<void> _copyExercisesDatabaseIfNeeded(String dbPath) async {
    SharedPreferences? prefs;
    int copiedVersion = 0;
    try {
      prefs = await SharedPreferences.getInstance();
      copiedVersion =
          prefs.getInt(DbPreferencesKeys.copiedExercisesDbVersion) ?? 0;
    } catch (_) {}

    final dbFile = File(dbPath);

    final shouldCopy =
        !await dbFile.exists() ||
        copiedVersion < AppConstants.exercisesDbVersion;

    if (!shouldCopy) {
      debugPrint('Exercises database already up to date.');
      return;
    }

    debugPrint('Copying exercises.db...');

    await dbFile.parent.create(recursive: true);

    try {
      if (await dbFile.exists()) {
        await dbFile.delete();
      }
    } catch (_) {}

    final data = await rootBundle.load('assets/exercises.db');

    final bytes = data.buffer.asUint8List();

    await dbFile.writeAsBytes(bytes, flush: true);

    try {
      await prefs?.setInt(
        DbPreferencesKeys.copiedExercisesDbVersion,
        AppConstants.exercisesDbVersion,
      );
    } catch (_) {}

    debugPrint(
      'Exercises database copied at version ${AppConstants.exercisesDbVersion}',
    );
  }
}
