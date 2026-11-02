import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/domain/models/home_state.dart';

void main() {
  group('HomeState', () {
    final baseDate = DateTime.utc(2024, 1, 1);
    final weekDays = List<DateTime>.generate(
      7,
      (i) => baseDate.add(Duration(days: i)),
    );

    test('constructs with required fields and defaults', () {
      final state = HomeState(
        selectedDate: baseDate,
        currentWeekDays: weekDays,
      );
      expect(state.isCreatingSession, false);
      expect(state.recommendedExercises, isEmpty);
      expect(state.hasIncompleteSession, false);
      expect(state.currentSession, isNull);
    });

    test('value equality', () {
      final a = HomeState(selectedDate: baseDate, currentWeekDays: weekDays);
      final b = HomeState(selectedDate: baseDate, currentWeekDays: weekDays);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('copyWith changes fields', () {
      final original = HomeState(
        selectedDate: baseDate,
        currentWeekDays: weekDays,
      );
      final edited = original.copyWith(
        isCreatingSession: true,
        hasIncompleteSession: true,
      );
      expect(edited.isCreatingSession, true);
      expect(edited.hasIncompleteSession, true);
      expect(edited.selectedDate, original.selectedDate);
      expect(edited, isNot(equals(original)));
    });

    test('copyWith without args returns equal instance', () {
      final original = HomeState(
        selectedDate: baseDate,
        currentWeekDays: weekDays,
      );
      final copy = original.copyWith();
      expect(copy, equals(original));
    });
  });
}
