import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/database/db_config.dart';
import 'package:move_your_body/core/database/tables/exercise_table.dart';
import 'package:move_your_body/core/database/tables/quick_plan_table.dart';
import 'package:move_your_body/core/database/tables/session_exercises_table.dart';
import 'package:move_your_body/core/database/tables/session_schedule_table.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/quick_plan_data.dart';
import 'package:move_your_body/core/model/session_data.dart';

import 'package:move_your_body/features/onboarding/repository/user_repository.dart';

final quickPlanRepositoryProvider = Provider<QuickPlanRepository>((ref) {
  return QuickPlanRepository(userRepository: ref.read(userRepositoryProvider));
});

class QuickPlanDefinition {
  final int planId;
  final String name;
  final String description;
  final String imagePath;
  final List<String> goalTagFilters;
  final List<String> bodyRegionFilters;

  const QuickPlanDefinition({
    required this.planId,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.goalTagFilters,
    required this.bodyRegionFilters,
  });
}

class QuickPlanRepository {
  final UserRepository _userRepository;

  QuickPlanRepository({required UserRepository userRepository})
    : _userRepository = userRepository;

  static const int _exercisesPerPlan = 12;

  static const List<QuickPlanDefinition> plans = [
    QuickPlanDefinition(
      planId: 1,
      name: 'Fat Burn Blast',
      description: 'High-intensity cardio to torch calories fast',
      imagePath: 'assets/images/fat_burn_blast.png',
      goalTagFilters: ['fat_burn', 'cardio', 'conditioning'],
      bodyRegionFilters: ['cardio_and_endurance'],
    ),
    QuickPlanDefinition(
      planId: 2,
      name: 'Core Crusher',
      description: 'Build a strong and stable core',
      imagePath: 'assets/images/core_crusher.png',
      goalTagFilters: ['core', 'core_strength', 'core_stability'],
      bodyRegionFilters: ['core'],
    ),
    QuickPlanDefinition(
      planId: 3,
      name: 'Upper Body Power',
      description: 'Strengthen your chest, arms & shoulders',
      imagePath: 'assets/images/upper_body_power.png',
      goalTagFilters: ['upper_body', 'strength'],
      bodyRegionFilters: ['upper_body'],
    ),
    QuickPlanDefinition(
      planId: 4,
      name: 'Lower Body Sculpt',
      description: 'Build powerful legs and glutes',
      imagePath: 'assets/images/lower_body_sculpt.png',
      goalTagFilters: ['lower_body_strength', 'glutes', 'strength'],
      bodyRegionFilters: ['lower_body'],
    ),
    QuickPlanDefinition(
      planId: 5,
      name: 'Yoga & Stretch',
      description: 'Relax, restore and improve flexibility',
      imagePath: 'assets/images/yoga_and_stretch.png',
      goalTagFilters: ['flexibility', 'stress_relief', 'mobility'],
      bodyRegionFilters: ['mobility_and_flexibility'],
    ),
  ];

  Future<List<QuickPlan>> fetchAllPlans() async {
    try {
      final db = await DatabaseService.instance.userDatabase;
      final maps = await db.query(QuickPlanTable.tableName);
      return maps.map((m) => QuickPlan.fromMap(m)).toList();
    } catch (e, st) {
      debugPrint('Error fetching quick plans: $e\n$st');
      return [];
    }
  }

  Future<void> seedPlansIfNeeded({bool force = false}) async {
    try {
      final db = await DatabaseService.instance.userDatabase;

      if (!force) {
        final existing = await db.query(QuickPlanTable.tableName, limit: 1);
        if (existing.isNotEmpty) {
          debugPrint('Plans already seeded, skipping.');
          return;
        }
      }

      await db.delete(QuickPlanTable.tableName);
      await db.delete(QuickPlanExercisesTable.tableName);

      final exercisesDb = await DatabaseService.instance.exercisesDatabase;
      final userData = await _userRepository.getUserData();

      if (userData == null) return;

      for (final plan in plans) {
        await db.insert(QuickPlanTable.tableName, {
          QuickPlanTable.id: plan.planId,
          QuickPlanTable.name: plan.name,
          QuickPlanTable.description: plan.description,
          QuickPlanTable.imagePath: plan.imagePath,
        });

        final exercises = await _fetchExercisesForPlan(
          exercisesDb,
          plan,
          userData,
        );

        for (int i = 0; i < exercises.length; i++) {
          await db.insert(QuickPlanExercisesTable.tableName, {
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
    dynamic exercisesDb,
    QuickPlanDefinition plan,
    dynamic userData,
  ) async {
    final allMatches = <Exercise>[];

    for (final tag in plan.goalTagFilters) {
      final maps = await exercisesDb.query(
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
      final maps = await exercisesDb.query(
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
      final db = await DatabaseService.instance.userDatabase;

      final planExercisesResult = await db.query(
        QuickPlanExercisesTable.tableName,
        where: '${QuickPlanExercisesTable.planId} = ?',
        whereArgs: [planId],
        orderBy: '${QuickPlanExercisesTable.orderIndex} ASC',
      );

      if (planExercisesResult.isEmpty) return null;

      final exerciseIds = planExercisesResult
          .map((e) => e[QuickPlanExercisesTable.exerciseId] as String)
          .toList();

      return await db.transaction<Session?>((txn) async {
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
}
