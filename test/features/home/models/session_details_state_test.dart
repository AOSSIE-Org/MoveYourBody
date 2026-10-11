import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/features/home/models/session_details_state.dart';
import 'package:move_your_body/core/model/session_data.dart';

void main() {
  group('SessionDetailsState', () {
    final dummySession = Session(
      id: 1,
      createdAt: DateTime.utc(2024, 1, 1),
      sessionStatus: SessionStatus.created,
      exercises: [],
    );

    test('constructs with defaults', () {
      final state = SessionDetailsState();
      expect(state.session, isNull);
      expect(state.exercises, isEmpty);
      expect(state.isLoading, true);
      expect(state.errorMessage, isNull);
      expect(state.exerciseDurations, isEmpty);
      expect(state.preparationTime, 5);
      expect(state.restTime, 20);
    });

    test('value equality', () {
      final a = SessionDetailsState();
      final b = SessionDetailsState();
      expect(a, equals(b));
    });

    test('copyWith changes fields', () {
      final original = SessionDetailsState();
      final edited = original.copyWith(session: dummySession, isLoading: false);
      expect(edited.session, dummySession);
      expect(edited.isLoading, false);
      expect(edited, isNot(equals(original)));
    });
  });
}
