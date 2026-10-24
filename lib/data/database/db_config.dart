import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/data/database/schema/exercise_schema.dart';
import 'package:move_your_body/data/database/schema/quick_plan_schema.dart';
import 'package:move_your_body/data/database/schema/session_exercises_schema.dart';
import 'package:move_your_body/data/database/schema/session_schedule_schema.dart';
import 'package:move_your_body/data/database/schema/tags_schema.dart';
import 'package:move_your_body/data/database/schema/user_schema.dart';
import 'package:move_your_body/data/database/tables/exercise_table.dart';
import 'package:move_your_body/data/database/tables/user_table.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

class DatabaseService {
  /// Version of the bundled exercises asset database, Increase this version only when `assets/exercises.db`;
  ///  is updated to trigger copying the new database to device storage on app launch.
  static const int exercisesDbVersion = 1;

  late final Future<Database> _userDatabaseFuture;
  Future<Database>? _exercisesDatabaseFuture;

  DatabaseService() {
    _userDatabaseFuture = _initDatabase();
  }

  Future<Database> get userDatabase => _userDatabaseFuture;
  Future<Database> get exercisesDatabase =>
      _exercisesDatabaseFuture ??= _initExercisesDatabase();

  Future<List<Map<String, dynamic>>> getAllExerciseRecords() async {
    final db = await exercisesDatabase;
    return await db.query(ExerciseTable.tableName);
  }

  Future<List<Map<String, dynamic>>> getExerciseRecordsByIds(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return [];
    final db = await exercisesDatabase;
    final placeholders = List.filled(ids.length, '?').join(', ');
    return await db.query(
      ExerciseTable.tableName,
      where: '${ExerciseTable.exerciseId} IN ($placeholders)',
      whereArgs: ids,
    );
  }

  Future<List<Map<String, dynamic>>> getUserRecords() async {
    final db = await _userDatabaseFuture;
    return await db.query(UserTable.tableName);
  }

  Future<int> insertUserRecord(Map<String, dynamic> data) async {
    final db = await _userDatabaseFuture;
    return await db.insert(
      UserTable.tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateUserRecord(
    Map<String, dynamic> data,
    String username,
  ) async {
    final db = await _userDatabaseFuture;
    return await db.update(
      UserTable.tableName,
      data,
      where: '${UserTable.username} = ?',
      whereArgs: [username],
    );
  }

  Future<int> deleteUserRecord(String username) async {
    final db = await _userDatabaseFuture;
    return await db.delete(
      UserTable.tableName,
      where: '${UserTable.username} = ?',
      whereArgs: [username],
    );
  }

  Future<List<Map<String, dynamic>>> queryUserDb(
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
    final db = await _userDatabaseFuture;
    return await db.query(
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
    Map<String, dynamic> values, {
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await _userDatabaseFuture;
    return await db.insert(table, values, conflictAlgorithm: conflictAlgorithm);
  }

  Future<int> updateUserDb(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final db = await _userDatabaseFuture;
    return await db.update(
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
    final db = await _userDatabaseFuture;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> rawQueryUserDb(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = await _userDatabaseFuture;
    return await db.rawQuery(sql, arguments);
  }

  Future<T> transactionUserDb<T>(
    Future<T> Function(Transaction txn) action, {
    bool? exclusive,
  }) async {
    final db = await _userDatabaseFuture;
    return await db.transaction<T>(action, exclusive: exclusive);
  }

  Future<List<Map<String, dynamic>>> queryExercisesDb(
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
    return await db.query(
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

  Future<List<Map<String, dynamic>>> rawQueryExercisesDb(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = await exercisesDatabase;
    return await db.rawQuery(sql, arguments);
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'move_your_body.db');
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
            'ALTER TABLE session_schedule ADD COLUMN quick_plan_id INTEGER',
          );
        }
        if (oldVersion < 7) {
          await db.execute(
            'ALTER TABLE quick_plans ADD COLUMN image_path TEXT',
          );
        }
        if (oldVersion < 8) {
          await db.execute(
            'ALTER TABLE quick_plans ADD COLUMN is_custom INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );
  }

  Future<Database> _initExercisesDatabase() async {
    final dbDirectory = await getDatabasesPath();
    final dbPath = join(dbDirectory, 'exercises.db');

    await _copyExercisesDatabaseIfNeeded(dbPath);

    debugPrint('EXERCISES DB PATH: $dbPath');

    return openDatabase(dbPath, readOnly: true);
  }

  Future<void> _copyExercisesDatabaseIfNeeded(String dbPath) async {
    final prefs = await SharedPreferences.getInstance();

    final copiedVersion = prefs.getInt('copied_exercises_db_version') ?? 0;

    final dbFile = File(dbPath);

    final shouldCopy =
        !await dbFile.exists() || copiedVersion < exercisesDbVersion;

    if (!shouldCopy) {
      debugPrint('Exercises database already up to date.');
      return;
    }

    debugPrint('Copying exercises.db...');

    await dbFile.parent.create(recursive: true);

    if (await dbFile.exists()) {
      await dbFile.delete();
    }

    final data = await rootBundle.load('assets/exercises.db');

    final bytes = data.buffer.asUint8List();

    await dbFile.writeAsBytes(bytes, flush: true);

    await prefs.setInt('copied_exercises_db_version', exercisesDbVersion);

    debugPrint('Exercises database copied at version $exercisesDbVersion');
  }
}
