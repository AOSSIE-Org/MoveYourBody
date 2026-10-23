import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:move_your_body/data/database/db_config.dart';
import 'package:move_your_body/data/database/tables/user_table.dart';
import 'package:move_your_body/data/database/tables/session_schedule_table.dart';
import 'package:move_your_body/data/database/tables/session_exercises_table.dart';
import 'package:move_your_body/data/database/tables/quick_plan_table.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseService Tests', () {
    test('userDatabase initializes and creates required tables', () async {
      final db = await DatabaseService.instance.userDatabase;

      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'",
      );
      final tableNames = tables.map((row) => row['name'] as String).toSet();

      expect(tableNames.contains(UserTable.tableName), isTrue);
      expect(tableNames.contains(SessionScheduleTable.tableName), isTrue);
      expect(tableNames.contains(SessionExercisesTable.tableName), isTrue);
      expect(tableNames.contains(QuickPlanTable.tableName), isTrue);
    });
  });
}
