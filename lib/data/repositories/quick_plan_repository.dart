import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/data/database/db_config.dart';
import 'package:move_your_body/data/database/tables/exercise_table.dart';
import 'package:move_your_body/data/database/tables/quick_plan_table.dart';
import 'package:move_your_body/data/database/tables/session_exercises_table.dart';
import 'package:move_your_body/data/database/tables/session_schedule_table.dart';
import 'package:move_your_body/domain/models/exercise_data.dart';
import 'package:move_your_body/domain/models/quick_plan_data.dart';
import 'package:move_your_body/domain/models/session_data.dart';

import 'package:move_your_body/domain/models/user_data.dart';
import 'package:move_your_body/utils/constants/app_constants.dart';

final quickPlanRepositoryProvider = Provider<QuickPlanRepository>((ref) {
  return QuickPlanRepository(dbService: ref.read(databaseServiceProvider));
});

class QuickPlanRepository {
  final DatabaseService _dbService;

  QuickPlanRepository({required DatabaseService dbService})
    : _dbService = dbService;

  static const int _exercisesPerPlan = QuickPlanConstants.exercisesPerPlan;

  static const List<QuickPlanDefinition> plans = QuickPlanConstants.presetPlans;

  Future<List<QuickPlan>> fetchAllPlans() async {
    try {
      final maps = await _dbService.queryUserDb(
        QuickPlanTable.tableName,
        where: '${QuickPlanTable.isCustom} = 0',
      );
      return maps.map((m) => QuickPlan.fromMap(m)).toList();
    } catch (e, st) {
      debugPrint('Error fetching quick plans: $e\n$st');
      return [];
    }
  }

  Future<List<QuickPlan>> fetchCustomPlans() async {
    try {
      final maps = await _dbService.queryUserDb(
        QuickPlanTable.tableName,
        where: '${QuickPlanTable.isCustom} = 1',
      );
      return maps.map((m) => QuickPlan.fromMap(m)).toList();
    } catch (e, st) {
      debugPrint('Error fetching custom plans: $e\n$st');
      return [];
    }
  }

  Future<void> seedPlansIfNeeded({bool force = false}) async {
    try {
      if (!force) {
        final existing = await _dbService.queryUserDb(
          QuickPlanTable.tableName,
          where: '${QuickPlanTable.isCustom} = 0',
          limit: 1,
        );
        if (existing.isNotEmpty) {
          debugPrint('Plans already seeded, skipping.');
          return;
        }
      }

      await _dbService.deleteUserDb(
        QuickPlanTable.tableName,
        where: '${QuickPlanTable.isCustom} = 0',
      );
      final presetPlanIds = plans.map((p) => p.planId).toList();
      final idPlaceholders = List.filled(presetPlanIds.length, '?').join(',');

      await _dbService.deleteUserDb(
        QuickPlanExercisesTable.tableName,
        where: '${QuickPlanExercisesTable.planId} IN ($idPlaceholders)',
        whereArgs: presetPlanIds,
      );

      final userRecords = await _dbService.getUserRecords();
      if (userRecords.isEmpty) return;
      final userData = UserData.fromMap(userRecords.first);

      for (final plan in plans) {
        await _dbService.insertUserDb(QuickPlanTable.tableName, {
          QuickPlanTable.id: plan.planId,
          QuickPlanTable.name: plan.name,
          QuickPlanTable.description: plan.description,
          QuickPlanTable.imagePath: plan.imagePath,
        });

        final exercises = await _fetchExercisesForPlan(plan, userData);

        for (int i = 0; i < exercises.length; i++) {
          await _dbService.insertUserDb(QuickPlanExercisesTable.tableName, {
            QuickPlanExercisesTable.planId: plan.planId,
            QuickPlanExercisesTable.exerciseId: exercises[i].exerciseId,
            QuickPlanExercisesTable.orderIndex: i,
          });
        }
      }

      debugPrint('Quick plans seeded successfully.');
    } catch (e, st) {
      debugPrint('Error seeding quick plans: $e\n$st');
    }
  }

  Future<List<Exercise>> _fetchExercisesForPlan(
    QuickPlanDefinition plan,
    dynamic userData,
  ) async {
    final allMatches = <Exercise>[];

    for (final tag in plan.goalTagFilters) {
      final maps = await _dbService.queryExercisesDb(
        ExerciseTable.tableName,
        where: '${ExerciseTable.goalTags} LIKE ?',
        whereArgs: ['%$tag%'],
      );
      for (final m in maps) {
        final ex = Exercise.fromMap(m);
        if (!allMatches.any((e) => e.exerciseId == ex.exerciseId)) {
          allMatches.add(ex);
        }
      }
    }

    for (final region in plan.bodyRegionFilters) {
      final maps = await _dbService.queryExercisesDb(
        ExerciseTable.tableName,
        where: '${ExerciseTable.bodyRegions} LIKE ?',
        whereArgs: ['%$region%'],
      );
      for (final m in maps) {
        final ex = Exercise.fromMap(m);
        if (!allMatches.any((e) => e.exerciseId == ex.exerciseId)) {
          allMatches.add(ex);
        }
      }
    }

    allMatches.shuffle();
    return allMatches.take(_exercisesPerPlan).toList();
  }

  Future<Session?> createSessionFromPlan(int planId) async {
    try {
      final planExercisesResult = await _dbService.queryUserDb(
        QuickPlanExercisesTable.tableName,
        where: '${QuickPlanExercisesTable.planId} = ?',
        whereArgs: [planId],
        orderBy: '${QuickPlanExercisesTable.orderIndex} ASC',
      );

      if (planExercisesResult.isEmpty) return null;

      final exerciseIds = planExercisesResult
          .map((e) => e[QuickPlanExercisesTable.exerciseId] as String)
          .toList();

      return await _dbService.transactionUserDb<Session?>((txn) async {
        final now = DateTime.now();

        final sessionId = await txn.insert(SessionScheduleTable.tableName, {
          SessionScheduleTable.createdAt: now.toIso8601String(),
          SessionScheduleTable.sessionStatus: SessionStatus.created.name,
          SessionScheduleTable.sessionDuration: 0,
          SessionScheduleTable.caloriesBurned: 0.0,
          SessionScheduleTable.isQuickPlan: 1,
          SessionScheduleTable.quickPlanId: planId,
        });

        final sessionExercises = <SessionExercise>[];

        for (int i = 0; i < exerciseIds.length; i++) {
          final seId = await txn.insert(SessionExercisesTable.tableName, {
            SessionExercisesTable.sessionId: sessionId,
            SessionExercisesTable.exerciseId: exerciseIds[i],
            SessionExercisesTable.orderIndex: i,
            SessionExercisesTable.liked: 0,
            SessionExercisesTable.performedDuration: 0,
            SessionExercisesTable.exerciseStatus:
                ExerciseStatus.notStarted.name,
            SessionExercisesTable.completedAt: null,
          });

          sessionExercises.add(
            SessionExercise(
              id: seId,
              sessionId: sessionId,
              exerciseId: exerciseIds[i],
              orderIndex: i,
              liked: false,
              performedDuration: 0,
              exerciseStatus: ExerciseStatus.notStarted,
            ),
          );
        }

        return Session(
          id: sessionId,
          createdAt: now,
          sessionStatus: SessionStatus.created,
          isQuickPlan: true,
          quickPlanId: planId,
          exercises: sessionExercises,
        );
      });
    } catch (e, st) {
      debugPrint('Error creating session from plan: $e\n$st');
      return null;
    }
  }

  Future<int?> createCustomPlan(String name, List<String> exerciseIds) async {
    try {
      return await _dbService.transactionUserDb<int?>((txn) async {
        final planId = await txn.insert(QuickPlanTable.tableName, {
          QuickPlanTable.name: name,
          QuickPlanTable.description: 'Custom Workout',
          QuickPlanTable.isCustom: 1,
        });

        for (int i = 0; i < exerciseIds.length; i++) {
          await txn.insert(QuickPlanExercisesTable.tableName, {
            QuickPlanExercisesTable.planId: planId,
            QuickPlanExercisesTable.exerciseId: exerciseIds[i],
            QuickPlanExercisesTable.orderIndex: i,
          });
        }

        return planId;
      });
    } catch (e, st) {
      debugPrint('Error creating custom plan: $e\n$st');
      return null;
    }
  }
}
