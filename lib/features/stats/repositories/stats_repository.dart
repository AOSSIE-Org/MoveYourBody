import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/database/db_config.dart';
import 'package:move_your_body/core/database/tables/session_schedule_table.dart';
import 'package:move_your_body/core/model/session_data.dart';

final statsRepositoryProvider = Provider((ref) {
  return StatsRepository();
});

class StatsRepository {
  Future<List<Session>> getCompletedSessions() async {
    final db = await DatabaseService.instance.userDatabase;

    final List<Map<String, dynamic>> maps = await db.query(
      SessionScheduleTable.tableName,
      where: '${SessionScheduleTable.sessionStatus} = ?',
      whereArgs: [SessionStatus.completed.name],
    );

    return List.generate(maps.length, (i) {
      return Session.fromMap(maps[i]);
    });
  }
}
