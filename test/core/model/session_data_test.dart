import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/domain/models/session_data.dart';

void main() {
  group('Session Data Models Tests', () {
    test('SessionExercise toMap and fromMap round-trip', () {
      final now = DateTime(2023, 10, 15, 10, 30);
      final exercise = SessionExercise(
        id: 1,
        sessionId: 10,
        exerciseId: 'ex_pushup',
        orderIndex: 0,
        liked: true,
        performedDuration: 45,
        exerciseStatus: ExerciseStatus.completed,
        completedAt: now,
      );

      final map = exercise.toMap();
      expect(map['id'], 1);
      expect(map['session_id'], 10);
      expect(map['exercise_id'], 'ex_pushup');
      expect(map['order_index'], 0);
      expect(map['liked'], 1);
      expect(map['performed_duration'], 45);
      expect(map['exercise_status'], 'completed');
      expect(map['completed_at'], now.toIso8601String());

      final parsed = SessionExercise.fromMap(map);
      expect(parsed.id, 1);
      expect(parsed.sessionId, 10);
      expect(parsed.exerciseId, 'ex_pushup');
      expect(parsed.liked, isTrue);
      expect(parsed.performedDuration, 45);
      expect(parsed.exerciseStatus, ExerciseStatus.completed);
      expect(parsed.completedAt, now);
    });

    test('Session toMap and fromMap round-trip', () {
      final now = DateTime(2023, 10, 15, 10, 0);
      final session = Session(
        id: 5,
        createdAt: now,
        sessionDuration: 30,
        sessionStatus: SessionStatus.completed,
        difficultyFeedback: 'Just right',
        intensityFeedback: 'Moderate',
        caloriesBurned: 180.5,
        isQuickPlan: true,
        quickPlanId: 2,
        quickPlanName: 'Core Workout',
      );

      final map = session.toMap();
      expect(map['id'], 5);
      expect(map['created_at'], now.toIso8601String());
      expect(map['session_duration'], 30);
      expect(map['session_status'], 'completed');
      expect(map['difficulty_feedback'], 'Just right');
      expect(map['intensity_feedback'], 'Moderate');
      expect(map['calories_burned'], 180.5);
      expect(map['is_quick_plan'], 1);
      expect(map['quick_plan_id'], 2);

      final parsed = Session.fromMap(map);
      expect(parsed.id, 5);
      expect(parsed.createdAt, now);
      expect(parsed.sessionDuration, 30);
      expect(parsed.sessionStatus, SessionStatus.completed);
      expect(parsed.caloriesBurned, 180.5);
      expect(parsed.isQuickPlan, isTrue);
      expect(parsed.quickPlanId, 2);
    });
  });
}
