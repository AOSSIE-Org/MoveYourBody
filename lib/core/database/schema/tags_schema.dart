import 'package:sqflite/sqflite.dart';
import 'package:move_your_body/core/database/tables/tags_table.dart';

class TagsDatabaseService {
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${TagsTable.tableName}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ${TagsTable.tagName} TEXT NOT NULL UNIQUE,
        ${TagsTable.tagType} TEXT NOT NULL,
        ${TagsTable.embedding} BLOB
      )
    ''');
  }
}
