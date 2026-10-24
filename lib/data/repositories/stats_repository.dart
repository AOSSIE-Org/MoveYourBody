import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/data/database/db_config.dart';
import 'package:move_your_body/data/database/tables/session_schedule_table.dart';
import 'package:move_your_body/domain/models/session_data.dart';

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  final dbService = ref.read(databaseServiceProvider);
  return StatsRepository(dbService);
});

class StatsRepository {
  final DatabaseService _dbService;

  StatsRepository(this._dbService);

  Future<List<Session>> getCompletedSessions() async {
    final List<Map<String, dynamic>> maps = await _dbService.rawQueryUserDb(
      '''
      SELECT s.*, q.name AS ${SessionScheduleTable.quickPlanName}
      FROM ${SessionScheduleTable.tableName} s
      LEFT JOIN quick_plans q ON s.${SessionScheduleTable.quickPlanId} = q.id
      WHERE s.${SessionScheduleTable.sessionStatus} = ?
    ''',
      [SessionStatus.completed.name],
    );

    return List.generate(maps.length, (i) {
      return Session.fromMap(maps[i]);
    });
  }
}
