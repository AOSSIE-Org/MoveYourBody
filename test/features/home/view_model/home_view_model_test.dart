import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/data/repositories/exercise_repository.dart';
import 'package:move_your_body/data/repositories/session_repository.dart';
import 'package:move_your_body/data/repositories/user_repository.dart';
import 'package:move_your_body/ui/home/view_models/home_view_model.dart';
import 'package:move_your_body/domain/models/session_data.dart';
import 'package:move_your_body/domain/models/user_data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:move_your_body/domain/models/enums/session_enums.dart';
import 'package:move_your_body/domain/models/exercise_data.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

class FakeExerciseRepository extends ExerciseRepository {
  List<Exercise> allExercises;
  FakeExerciseRepository({this.allExercises = const []});

  @override
  Future<List<Exercise>> build() async => allExercises;

  @override
  Future<List<Exercise>> getAllExercises() async => allExercises;

  @override
  Future<List<Exercise>> getExercisesByIds(List<String> exerciseIds) async {
    final map = {for (final e in allExercises) e.exerciseId: e};
    return exerciseIds.where(map.containsKey).map((id) => map[id]!).toList();
  }
}

class FakeUserRepository extends UserRepository {
  UserData? user;
  FakeUserRepository({this.user});

  @override
  Future<UserData?> build() async => user;

  @override
  Future<UserData?> getUserData() async => user;
}

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
    late FakeExerciseRepository fakeExerciseRepo;
    late FakeUserRepository fakeUserRepo;

    setUp(() {
      mockSessionRepo = MockSessionRepository();
      fakeExerciseRepo = FakeExerciseRepository();
      fakeUserRepo = FakeUserRepository();

      container = ProviderContainer(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(mockSessionRepo),
          exerciseRepositoryProvider.overrideWith(() => fakeExerciseRepo),
          userRepositoryProvider.overrideWith(() => fakeUserRepo),
        ],
      );
    });

    test('initial state has correct dates and loads data', () async {
      when(
        () => mockSessionRepo.getLatestIncompleteSession(),
      ).thenAnswer((_) async => null);
      final user = MockUserData();
      fakeUserRepo.user = user;
      when(() => user.goalTags).thenReturn([]);
      when(() => user.targetBodyRegion).thenReturn([]);
      when(() => user.difficulty).thenReturn('');
      when(() => user.intensity).thenReturn('');
      when(() => user.healthIssueTags).thenReturn([]);
      when(() => user.equipments).thenReturn([]);
      when(
        () => mockSessionRepo.getRecentExerciseIds(any()),
      ).thenAnswer((_) async => []);

      final state = await container.read(homeViewModelProvider.future);
      expect(state.currentWeekDays.length, 7);
      expect(state.hasIncompleteSession, isFalse);
    });

    test('loads incomplete session if exists', () async {
      final session = Session(
        id: 1,
        createdAt: DateTime.now(),
        sessionStatus: SessionStatus.created,
        exercises: [],
      );

      when(
        () => mockSessionRepo.getLatestIncompleteSession(),
      ).thenAnswer((_) async => session);

      final state = await container.read(homeViewModelProvider.future);
      expect(state.hasIncompleteSession, isTrue);
      expect(state.currentSession, session);
    });
  });
}
