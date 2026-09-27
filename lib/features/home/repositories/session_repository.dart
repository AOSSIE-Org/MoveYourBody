import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/database/db_config.dart';
import 'package:move_your_body/core/database/tables/session_exercises_table.dart';
import 'package:move_your_body/core/database/tables/session_schedule_table.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/features/home/services/recommendation_service.dart';
import 'package:move_your_body/features/home/services/safety_filter_service.dart';
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

      final recentExerciseIds = await getRecentExerciseIds(SafetyFilterService.sessionsToSkip);
      final recommendedExercises = await _recommendationService
          .recommendExercises(userData, recentExerciseIds);

      final db = await DatabaseService.instance.userDatabase;

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
      final db = await DatabaseService.instance.userDatabase;

      final sessionResult = await db.query(
        SessionScheduleTable.tableName,
        where: '${SessionScheduleTable.sessionStatus} IN (?, ?) AND ${SessionScheduleTable.isQuickPlan} = 0',
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
      final db = await DatabaseService.instance.userDatabase;

      final List<Map<String, dynamic>> sessionResult = await db.rawQuery('''
        SELECT s.*, q.name AS ${SessionScheduleTable.quickPlanName}
        FROM ${SessionScheduleTable.tableName} s
        LEFT JOIN quick_plans q ON s.${SessionScheduleTable.quickPlanId} = q.id
        WHERE s.${SessionScheduleTable.id} = ?
        LIMIT 1
      ''', [sessionId]);

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
      final db = await DatabaseService.instance.userDatabase;

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
      final db = await DatabaseService.instance.userDatabase;
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
      final db = await DatabaseService.instance.userDatabase;
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
      final db = await DatabaseService.instance.userDatabase;
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

  Future<List<String>> getRecentExerciseIds(int sessionCount) async {
    try {
      final db = await DatabaseService.instance.userDatabase;
      
      final sessionResult = await db.query(
        SessionScheduleTable.tableName,
        columns: [SessionScheduleTable.id],
        where: '${SessionScheduleTable.sessionStatus} = ?',
        whereArgs: [SessionStatus.completed.name],
        orderBy: '${SessionScheduleTable.createdAt} DESC',
        limit: sessionCount,
      );
      
      if (sessionResult.isEmpty) return [];
      
      final sessionIds = sessionResult.map((e) => e[SessionScheduleTable.id] as int).toList();
      
      final exerciseResult = await db.query(
        SessionExercisesTable.tableName,
        columns: [SessionExercisesTable.exerciseId],
        where: '${SessionExercisesTable.sessionId} IN (${List.filled(sessionIds.length, '?').join(', ')})',
        whereArgs: sessionIds,
      );
      
      return exerciseResult.map((e) => e[SessionExercisesTable.exerciseId] as String).toSet().toList();
    } catch (e, stackTrace) {
      debugPrint('Error getting recent exercise IDs: $e');
      debugPrint('$stackTrace');
      return [];
    }
  }

  Future<List<Session>> getLastThreeCompletedSessions() async {
    try {
      final db = await DatabaseService.instance.userDatabase;
      
      final List<Map<String, dynamic>> sessionResult = await db.rawQuery('''
        SELECT s.*, q.name AS ${SessionScheduleTable.quickPlanName}
        FROM ${SessionScheduleTable.tableName} s
        LEFT JOIN quick_plans q ON s.${SessionScheduleTable.quickPlanId} = q.id
        WHERE s.${SessionScheduleTable.sessionStatus} = ?
        ORDER BY s.${SessionScheduleTable.createdAt} DESC
        LIMIT 3
      ''', [SessionStatus.completed.name]);

      return sessionResult.map((e) => Session.fromMap(e)).toList();
    } catch (e, stackTrace) {
      debugPrint('Error fetching last 3 completed sessions: $e');
      debugPrint('$stackTrace');
      return [];
    }
  }

  Future<List<Session>> getAllSessions() async {
    try {
      final db = await DatabaseService.instance.userDatabase;
      final List<Map<String, dynamic>> sessionResult = await db.rawQuery('''
        SELECT s.*, q.name AS ${SessionScheduleTable.quickPlanName}
        FROM ${SessionScheduleTable.tableName} s
        LEFT JOIN quick_plans q ON s.${SessionScheduleTable.quickPlanId} = q.id
      ''');
      return sessionResult.map((e) => Session.fromMap(e)).toList();
    } catch (e) {
      debugPrint('Error getting all sessions: $e');
      return [];
    }
  }

  Future<void> debugPrintAllSessions() async {
    try {
      final db = await DatabaseService.instance.userDatabase;
      
      final sessionResult = await db.query(SessionScheduleTable.tableName);

      debugPrint('=== ALL SESSIONS IN DATABASE ===');
      for (var sessionMap in sessionResult) {
        final session = Session.fromMap(sessionMap);
        debugPrint('Session ID: ${session.id} | Status: ${session.sessionStatus.name}');
        debugPrint('Duration: ${session.sessionDuration}s | Calories: ${session.caloriesBurned}');
        debugPrint('Difficulty Feedback: ${session.difficultyFeedback}');
        debugPrint('Intensity Feedback: ${session.intensityFeedback}');
        debugPrint('----------------------------------');
      }
      debugPrint('================================');
    } catch (e, stackTrace) {
      debugPrint('Error printing sessions: $e');
      debugPrint('$stackTrace');
    }
  }
}
