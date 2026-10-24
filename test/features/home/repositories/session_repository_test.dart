import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/data/database/tables/user_table.dart';
import 'package:move_your_body/data/repositories/session_repository.dart';
import 'package:move_your_body/domain/models/session_data.dart';
import 'package:move_your_body/domain/models/user_data.dart';
import 'package:move_your_body/data/services/recommendation_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:move_your_body/data/database/db_config.dart';

class MockRecommendationService extends Mock implements RecommendationService {}

class FakeUserData extends Fake implements UserData {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    registerFallbackValue(FakeUserData());
  });

  group('SessionRepository', () {
    late SessionRepository repo;
    late MockRecommendationService mockRecommendationService;

    setUp(() async {
      mockRecommendationService = MockRecommendationService();
      repo = SessionRepository(
        recommendationService: mockRecommendationService,
        dbService: DatabaseService(),
      );

      final db = await DatabaseService().userDatabase;
      try {
        await db.delete('session_schedule');
        await db.delete('session_exercise');
        await db.delete(UserTable.tableName);
      } catch (_) {}
    });

    test('createSession returns null when user data is null', () async {
      final session = await repo.createSession();
      expect(session, isNull);
    });

    test('createSession creates session when user data exists', () async {
      await DatabaseService().insertUserRecord({
        UserTable.username: 'test_user',
        UserTable.height: 170,
        UserTable.weight: 70,
        UserTable.age: 25,
        UserTable.goalTags: '',
        UserTable.customGoal: '',
        UserTable.healthIssueTags: '',
        UserTable.customHealthIssue: '',
        UserTable.difficulty: 'beginner',
        UserTable.intensity: 'low',
        UserTable.targetBodyRegion: '',
        UserTable.equipments: '',
        UserTable.isOnboarded: 1,
      });
      when(
        () => mockRecommendationService.recommendExercises(any(), any()),
      ).thenAnswer((_) async => []);

      final session = await repo.createSession();

      expect(session, isA<Session>());
      expect(session?.exercises, isEmpty);
      expect(session?.sessionStatus, SessionStatus.created);
    });

    test(
      'getLatestIncompleteSession returns null when database is empty',
      () async {
        final session = await repo.getLatestIncompleteSession();
        expect(session, isNull);
      },
    );
  });
}
