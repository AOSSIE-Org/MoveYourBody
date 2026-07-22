import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/database/db_config.dart';
import 'package:move_your_body/core/database/tables/session_exercises_table.dart';
import 'package:move_your_body/core/database/tables/session_schedule_table.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/features/home/services/recommendation_service.dart';
import 'package:move_your_body/features/onboarding/repository/user_repository.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(
    userRepository: ref.read(userRepositoryProvider),
    recommendationService: ref.read(recommendationServiceProvider),
  );
});

class SessionRepository {
  final UserRepository _userRepository;
  final RecommendationService _recommendationService;

  SessionRepository({
    required UserRepository userRepository,
    required RecommendationService recommendationService,
  }) : _userRepository = userRepository,
       _recommendationService = recommendationService;

  Future<Session?> createSession() async {
    try {
      final userData = await _userRepository.getUserData();
      if (userData == null) {
        return null;
      }

      final recommendedExercises = await _recommendationService
          .recommendExercises(userData);

      final db = await DatabaseService.instance.database;

      return await db.transaction<Session?>((txn) async {
        final now = DateTime.now();

        final sessionMap = {
          SessionScheduleTable.createdAt: now.toIso8601String(),
          SessionScheduleTable.sessionStatus: SessionStatus.created.name,
          SessionScheduleTable.sessionDuration: 0,
          SessionScheduleTable.caloriesBurned: 0.0,
        };

        final sessionId = await txn.insert(
          SessionScheduleTable.tableName,
          sessionMap,
        );

        final List<SessionExercise> sessionExercises = [];

        for (int i = 0; i < recommendedExercises.length; i++) {
          final exercise = recommendedExercises[i];
          final sessionExerciseMap = {
            SessionExercisesTable.sessionId: sessionId,
            SessionExercisesTable.exerciseId: exercise.exerciseId,
            SessionExercisesTable.orderIndex: i,
            SessionExercisesTable.liked: 0,
            SessionExercisesTable.performedDuration: 0,
            SessionExercisesTable.exerciseStatus:
                ExerciseStatus.notStarted.name,
            SessionExercisesTable.completedAt: null,
          };

          final exerciseSessionId = await txn.insert(
            SessionExercisesTable.tableName,
            sessionExerciseMap,
          );

          sessionExercises.add(
            SessionExercise(
              id: exerciseSessionId,
              sessionId: sessionId,
              exerciseId: exercise.exerciseId,
              orderIndex: i,
              liked: false,
              performedDuration: 0,
              exerciseStatus: ExerciseStatus.notStarted,
              completedAt: null,
            ),
          );
        }

        return Session(
          id: sessionId,
          createdAt: now,
          sessionDuration: 0,
          sessionStatus: SessionStatus.created,
          caloriesBurned: 0.0,
          exercises: sessionExercises,
        );
      });
    } catch (e, stackTrace) {
      debugPrint('Error creating session: $e');
      debugPrint('Stacktrace: $stackTrace');
      return null;
    }
  }

  Future<Session?> getLatestIncompleteSession() async {
    try {
      final db = await DatabaseService.instance.database;

      final sessionResult = await db.query(
        SessionScheduleTable.tableName,
        where: '${SessionScheduleTable.sessionStatus} IN (?, ?)',
        whereArgs: [SessionStatus.created.name, SessionStatus.inProgress.name],
        orderBy: '${SessionScheduleTable.createdAt} DESC',
        limit: 1,
      );

      if (sessionResult.isEmpty) {
        return null;
      }

      final session = Session.fromMap(sessionResult.first);

      final exercisesResult = await db.query(
        SessionExercisesTable.tableName,
        where: '${SessionExercisesTable.sessionId} = ?',
        whereArgs: [session.id],
        orderBy: '${SessionExercisesTable.orderIndex} ASC',
      );

      final exercises = exercisesResult
          .map((e) => SessionExercise.fromMap(e))
          .toList();

      return session.copyWith(exercises: exercises);
    } catch (e, stackTrace) {
      debugPrint('Error fetching latest incomplete session: $e');
      debugPrint('$stackTrace');
      return null;
    }
  }

  Future<Session?> getSessionById(int sessionId) async {
    try {
      final db = await DatabaseService.instance.database;

      final sessionResult = await db.query(
        SessionScheduleTable.tableName,
        where: '${SessionScheduleTable.id} = ?',
        whereArgs: [sessionId],
        limit: 1,
      );

      if (sessionResult.isEmpty) {
        return null;
      }

      final session = Session.fromMap(sessionResult.first);

      final exercisesResult = await db.query(
        SessionExercisesTable.tableName,
        where: '${SessionExercisesTable.sessionId} = ?',
        whereArgs: [session.id],
        orderBy: '${SessionExercisesTable.orderIndex} ASC',
      );

      final exercises = exercisesResult
          .map((e) => SessionExercise.fromMap(e))
          .toList();

      return session.copyWith(exercises: exercises);
    } catch (e, stackTrace) {
      debugPrint('Error fetching session by id: $e');
      debugPrint('$stackTrace');
      return null;
    }
  }

  Future<Session?> createSessionFromExercises(List<Exercise> exercises) async {
    try {
      final db = await DatabaseService.instance.database;

      return await db.transaction<Session?>((txn) async {
        final now = DateTime.now();

        final sessionMap = {
          SessionScheduleTable.createdAt: now.toIso8601String(),
          SessionScheduleTable.sessionStatus: SessionStatus.created.name,
          SessionScheduleTable.sessionDuration: 0,
          SessionScheduleTable.caloriesBurned: 0.0,
        };

        final sessionId = await txn.insert(
          SessionScheduleTable.tableName,
          sessionMap,
        );

        final List<SessionExercise> sessionExercises = [];

        for (int i = 0; i < exercises.length; i++) {
          final exercise = exercises[i];
          final sessionExerciseMap = {
            SessionExercisesTable.sessionId: sessionId,
            SessionExercisesTable.exerciseId: exercise.exerciseId,
            SessionExercisesTable.orderIndex: i,
            SessionExercisesTable.liked: 0,
            SessionExercisesTable.performedDuration: 0,
            SessionExercisesTable.exerciseStatus:
                ExerciseStatus.notStarted.name,
            SessionExercisesTable.completedAt: null,
          };

          final exerciseSessionId = await txn.insert(
            SessionExercisesTable.tableName,
            sessionExerciseMap,
          );

          sessionExercises.add(
            SessionExercise(
              id: exerciseSessionId,
              sessionId: sessionId,
              exerciseId: exercise.exerciseId,
              orderIndex: i,
              liked: false,
              performedDuration: 0,
              exerciseStatus: ExerciseStatus.notStarted,
              completedAt: null,
            ),
          );
        }

        return Session(
          id: sessionId,
          createdAt: now,
          sessionDuration: 0,
          sessionStatus: SessionStatus.created,
          caloriesBurned: 0.0,
          exercises: sessionExercises,
        );
      });
    } catch (e, stackTrace) {
      debugPrint('Error creating session from exercises: $e');
      debugPrint('Stacktrace: $stackTrace');
      return null;
    }
  }

  Future<void> updateSessionStatus(int sessionId, SessionStatus status) async {
    try {
      final db = await DatabaseService.instance.database;
      await db.update(
        SessionScheduleTable.tableName,
        {SessionScheduleTable.sessionStatus: status.name},
        where: '${SessionScheduleTable.id} = ?',
        whereArgs: [sessionId],
      );
    } catch (e) {
      debugPrint('Error updating session status: $e');
    }
  }

  Future<void> updateSessionExerciseStatus({
    required int sessionExerciseId,
    required ExerciseStatus status,
    required int performedDuration,
  }) async {
    try {
      final db = await DatabaseService.instance.database;
      await db.update(
        SessionExercisesTable.tableName,
        {
          SessionExercisesTable.exerciseStatus: status.name,
          SessionExercisesTable.performedDuration: performedDuration,
          SessionExercisesTable.completedAt: DateTime.now().toIso8601String(),
        },
        where: '${SessionExercisesTable.id} = ?',
        whereArgs: [sessionExerciseId],
      );
    } catch (e) {
      debugPrint('Error updating session exercise: $e');
    }
  }

  Future<void> completeSession({
    required int sessionId,
    required int totalDuration,
    required double caloriesBurned,
    String? difficultyFeedback,
    String? intensityFeedback,
  }) async {
    try {
      final db = await DatabaseService.instance.database;
      await db.update(
        SessionScheduleTable.tableName,
        {
          SessionScheduleTable.sessionStatus: SessionStatus.completed.name,
          SessionScheduleTable.sessionDuration: totalDuration,
          SessionScheduleTable.caloriesBurned: caloriesBurned,
          SessionScheduleTable.difficultyFeedback: ?difficultyFeedback,
          SessionScheduleTable.intensityFeedback: ?intensityFeedback,
        },
        where: '${SessionScheduleTable.id} = ?',
        whereArgs: [sessionId],
      );
    } catch (e) {
      debugPrint('Error completing session: $e');
    }
  }
}
