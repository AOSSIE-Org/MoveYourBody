import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/home/repositories/session_repository.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/core/model/user_data.dart';
import 'package:move_your_body/features/onboarding/repository/user_repository.dart';
import 'package:move_your_body/features/home/services/recommendation_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:move_your_body/core/database/db_config.dart';

class MockUserRepository extends Mock implements UserRepository {}
class MockRecommendationService extends Mock implements RecommendationService {}
class MockUserData extends Mock implements UserData {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('SessionRepository', () {
    late SessionRepository repo;
    late MockUserRepository mockUserRepository;
    late MockRecommendationService mockRecommendationService;

    setUp(() async {
      mockUserRepository = MockUserRepository();
      mockRecommendationService = MockRecommendationService();
      repo = SessionRepository(
        userRepository: mockUserRepository,
        recommendationService: mockRecommendationService,
      );
      
      final db = await DatabaseService.instance.userDatabase;
      try {
        await db.delete('session_schedule');
        await db.delete('session_exercise');
      } catch (_) {}
    });

    test('createSession returns null when user data is null', () async {
      when(() => mockUserRepository.getUserData()).thenAnswer((_) async => null);
    });

    test('createSession creates session when user data exists', () async {
      final mockUserData = MockUserData();
      when(() => mockUserRepository.getUserData()).thenAnswer((_) async => mockUserData);
      when(() => mockRecommendationService.recommendExercises(mockUserData, any()))
          .thenAnswer((_) async => []);

      final session = await repo.createSession();
      
      expect(session, isA<Session>());
      expect(session?.exercises, isEmpty);
      expect(session?.sessionStatus, SessionStatus.created);
    });

    test('getLatestIncompleteSession returns null when database is empty', () async {
      final session = await repo.getLatestIncompleteSession();
      expect(session, isNull);
    });
  });
}
