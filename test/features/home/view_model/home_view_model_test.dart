import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/home/repositories/exercise_repository.dart';
import 'package:move_your_body/features/home/repositories/session_repository.dart';
import 'package:move_your_body/features/onboarding/repository/user_repository.dart';
import 'package:move_your_body/features/home/services/recommendation_service.dart';
import 'package:move_your_body/features/home/view_model/home_view_model.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/core/model/user_data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockSessionRepository extends Mock implements SessionRepository {}
class MockExerciseRepository extends Mock implements ExerciseRepository {}
class MockUserRepository extends Mock implements UserRepository {}
class MockRecommendationService extends Mock implements RecommendationService {}
class MockUserData extends Mock implements UserData {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('HomeViewModel', () {
    late ProviderContainer container;
    late MockSessionRepository mockSessionRepo;
    late MockExerciseRepository mockExerciseRepo;
    late MockUserRepository mockUserRepo;
    late MockRecommendationService mockRecommendationService;

    setUp(() {
      mockSessionRepo = MockSessionRepository();
      mockExerciseRepo = MockExerciseRepository();
      mockUserRepo = MockUserRepository();
      mockRecommendationService = MockRecommendationService();

      container = ProviderContainer(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(mockSessionRepo),
          exerciseRepositoryProvider.overrideWithValue(mockExerciseRepo),
          userRepositoryProvider.overrideWithValue(mockUserRepo),
          recommendationServiceProvider.overrideWithValue(mockRecommendationService),
        ],
      );
    });



    test('initial state has correct dates and loads data', () async {
      when(() => mockSessionRepo.getLatestIncompleteSession()).thenAnswer((_) async => null);
      final user = MockUserData();
      when(() => mockUserRepo.getUserData()).thenAnswer((_) async => user);
      when(() => mockSessionRepo.getRecentExerciseIds(any())).thenAnswer((_) async => []);
      when(() => mockRecommendationService.recommendExercises(user, [])).thenAnswer((_) async => []);

      container.listen(homeViewModelProvider, (_, __) {});
      final state = container.read(homeViewModelProvider);
      
      expect(state.currentWeekDays.length, 7);
      expect(state.isLoading, isFalse); 


      await Future.delayed(const Duration(milliseconds: 50));

      final nextState = container.read(homeViewModelProvider);
      expect(nextState.isLoading, isFalse);
      expect(nextState.hasIncompleteSession, isFalse);
    });

    test('loads incomplete session if exists', () async {
      final session = Session(
        id: 1,
        createdAt: DateTime.now(),
        sessionStatus: SessionStatus.created,
        exercises: [],
      );

      when(() => mockSessionRepo.getLatestIncompleteSession()).thenAnswer((_) async => session);
      when(() => mockExerciseRepo.getExercisesByIds([])).thenAnswer((_) async => []);

      container.listen(homeViewModelProvider, (_, __) {});
      container.read(homeViewModelProvider);
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(homeViewModelProvider);
      expect(state.hasIncompleteSession, isTrue);
      expect(state.currentSession, session);
    });
  });
}
