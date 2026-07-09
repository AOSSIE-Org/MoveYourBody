import 'package:move_your_body/core/database/schema/exercise_schema.dart';
import 'package:move_your_body/core/database/schema/tags_schema.dart';
import 'package:move_your_body/core/database/schema/user_schema.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = Provider<Database>((ref) {
  throw UnimplementedError('databaseProvider not initialized');
});

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();

  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'move_your_body.db');
    debugPrint('DB PATH: $path');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await UserDatabaseService.createTable(db);
        await ExerciseDatabaseService.createTable(db);
        await TagsDatabaseService.createTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await ExerciseDatabaseService.createTable(db);
          await TagsDatabaseService.createTable(db);
        }
      },
    );
  }
}
