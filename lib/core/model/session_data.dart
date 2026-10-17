import 'package:move_your_body/core/database/tables/session_exercises_table.dart';
import 'package:move_your_body/core/database/tables/session_schedule_table.dart';

enum SessionStatus { created, inProgress, completed}

enum ExerciseStatus { notStarted, completed, skipped }

class SessionExercise {
  final int? id;
  final int sessionId;
  final String exerciseId;
  final int orderIndex;
  final bool liked;
  final int performedDuration;
  final ExerciseStatus exerciseStatus;
  final DateTime? completedAt;

  const SessionExercise({
    this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.orderIndex,
    required this.liked,
    required this.performedDuration,
    required this.exerciseStatus,
    this.completedAt,
  });

  factory SessionExercise.fromMap(Map<String, dynamic> map) {
    return SessionExercise(
      id: map[SessionExercisesTable.id] as int?,
      sessionId: map[SessionExercisesTable.sessionId] as int,
      exerciseId: map[SessionExercisesTable.exerciseId] as String,
      orderIndex: map[SessionExercisesTable.orderIndex] as int,
      liked: (map[SessionExercisesTable.liked] as int?) == 1,
      performedDuration:
          map[SessionExercisesTable.performedDuration] as int? ?? 0,
      exerciseStatus: ExerciseStatus.values.byName(
        map[SessionExercisesTable.exerciseStatus] as String? ?? 'notStarted',
      ),
      completedAt: map[SessionExercisesTable.completedAt] != null
          ? DateTime.tryParse(map[SessionExercisesTable.completedAt] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) SessionExercisesTable.id: id,
      SessionExercisesTable.sessionId: sessionId,
      SessionExercisesTable.exerciseId: exerciseId,
      SessionExercisesTable.orderIndex: orderIndex,
      SessionExercisesTable.liked: liked ? 1 : 0,
      SessionExercisesTable.performedDuration: performedDuration,
      SessionExercisesTable.exerciseStatus: exerciseStatus.name,
      SessionExercisesTable.completedAt: completedAt?.toIso8601String(),
    };
  }
}

class Session {
  final int? id;
  final DateTime createdAt;
  final int? sessionDuration;
  final SessionStatus sessionStatus;
  final String? difficultyFeedback;
  final String? intensityFeedback;
  final double? caloriesBurned;
  final List<SessionExercise> exercises;

  const Session({
    this.id,
    required this.createdAt,
    this.sessionDuration,
    required this.sessionStatus,
    this.difficultyFeedback,
    this.intensityFeedback,
    this.caloriesBurned,
    this.exercises = const [],
  });

  factory Session.fromMap(
    Map<String, dynamic> map, {
    List<SessionExercise> exercises = const [],
  }) {
    return Session(
      id: map[SessionScheduleTable.id] as int?,
      createdAt: DateTime.parse(map[SessionScheduleTable.createdAt] as String),
      sessionDuration: map[SessionScheduleTable.sessionDuration] as int?,
      sessionStatus: SessionStatus.values.byName(
        map[SessionScheduleTable.sessionStatus] as String? ?? 'created',
      ),
      difficultyFeedback:
          map[SessionScheduleTable.difficultyFeedback] as String?,
      intensityFeedback: map[SessionScheduleTable.intensityFeedback] as String?,
      caloriesBurned: (map[SessionScheduleTable.caloriesBurned] as num?)
          ?.toDouble(),
      exercises: exercises,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) SessionScheduleTable.id: id,
      SessionScheduleTable.createdAt: createdAt.toIso8601String(),
      SessionScheduleTable.sessionDuration: sessionDuration,
      SessionScheduleTable.sessionStatus: sessionStatus.name,
      SessionScheduleTable.difficultyFeedback: difficultyFeedback,
      SessionScheduleTable.intensityFeedback: intensityFeedback,
      SessionScheduleTable.caloriesBurned: caloriesBurned,
    };
  }

  Session copyWith({
    int? id,
    DateTime? createdAt,
    int? sessionDuration,
    SessionStatus? sessionStatus,
    String? difficultyFeedback,
    String? intensityFeedback,
    double? caloriesBurned,
    List<SessionExercise>? exercises,
  }) {
    return Session(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      difficultyFeedback: difficultyFeedback ?? this.difficultyFeedback,
      intensityFeedback: intensityFeedback ?? this.intensityFeedback,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      exercises: exercises ?? this.exercises,
    );
  }
}
