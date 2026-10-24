import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/data/repositories/session_repository.dart';
import 'package:move_your_body/domain/models/session_data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:move_your_body/data/database/db_config.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('SessionRepository', () {
    late SessionRepository repo;

    setUp(() async {
      repo = SessionRepository(dbService: DatabaseService());

      final db = await DatabaseService().userDatabase;
      try {
        await db.delete('session_schedule');
        await db.delete('session_exercise');
      } catch (_) {}
    });

    test(
      'createSessionFromExercises creates session with given exercises',
      () async {
        final session = await repo.createSessionFromExercises([]);

        expect(session, isA<Session>());
        expect(session?.exercises, isEmpty);
        expect(session?.sessionStatus, SessionStatus.created);
      },
    );

    test(
      'getLatestIncompleteSession returns null when database is empty',
      () async {
        final session = await repo.getLatestIncompleteSession();
        expect(session, isNull);
      },
    );
  });
}
