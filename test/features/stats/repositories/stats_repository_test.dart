import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:move_your_body/features/stats/repositories/stats_repository.dart';
import 'package:move_your_body/core/database/db_config.dart';
import 'package:move_your_body/core/database/tables/session_schedule_table.dart';
import 'package:move_your_body/core/model/session_data.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('StatsRepository Tests', () {
    late StatsRepository repository;

    setUp(() async {
      repository = StatsRepository();

      final db = await DatabaseService.instance.userDatabase;
      await db.delete(SessionScheduleTable.tableName);
    });

    test('getCompletedSessions should return only completed sessions', () async {
      final db = await DatabaseService.instance.userDatabase;

      final completedSession = Session(
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        sessionDuration: 30,
        sessionStatus: SessionStatus.completed,
        caloriesBurned: 250.0,
      );

      final inProgressSession = Session(
        createdAt: DateTime.now(),
        sessionDuration: 15,
        sessionStatus: SessionStatus.inProgress,
        caloriesBurned: 100.0,
      );

      await db.insert(SessionScheduleTable.tableName, completedSession.toMap());
      await db.insert(
        SessionScheduleTable.tableName,
        inProgressSession.toMap(),
      );

      final result = await repository.getCompletedSessions();

      expect(result, isNotEmpty);
      expect(result.length, 1);
      expect(result.first.sessionStatus, SessionStatus.completed);
      expect(result.first.caloriesBurned, 250.0);
    });

    test(
      'getCompletedSessions should return empty list if no completed sessions exist',
      () async {
        final db = await DatabaseService.instance.userDatabase;

        final inProgressSession = Session(
          createdAt: DateTime.now(),
          sessionStatus: SessionStatus.inProgress,
        );

        await db.insert(
          SessionScheduleTable.tableName,
          inProgressSession.toMap(),
        );

        final result = await repository.getCompletedSessions();

        expect(result, isEmpty);
      },
    );
  });
}
