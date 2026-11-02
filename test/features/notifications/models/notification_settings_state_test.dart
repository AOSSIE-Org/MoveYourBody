import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/domain/models/notification_settings_state.dart';

void main() {
  group('NotificationSettingsState Tests', () {
    test('default constructor sets correct defaults', () {
      const state = NotificationSettingsState();
      expect(state.times, isEmpty);
      expect(state.isLoading, isTrue);
    });

    test('constructor sets custom values properly', () {
      const times = [
        TimeOfDay(hour: 8, minute: 0),
        TimeOfDay(hour: 18, minute: 30),
      ];
      const state = NotificationSettingsState(times: times, isLoading: false);
      expect(state.times, times);
      expect(state.isLoading, isFalse);
    });

    test('copyWith updates times only', () {
      const state = NotificationSettingsState(isLoading: true);
      const newTimes = [TimeOfDay(hour: 7, minute: 15)];
      final updated = state.copyWith(times: newTimes);

      expect(updated.times, newTimes);
      expect(updated.isLoading, isTrue);
    });

    test('copyWith updates isLoading only', () {
      const times = [TimeOfDay(hour: 9, minute: 0)];
      const state = NotificationSettingsState(times: times, isLoading: true);
      final updated = state.copyWith(isLoading: false);

      expect(updated.times, times);
      expect(updated.isLoading, isFalse);
    });

    test('copyWith with null parameters preserves existing values', () {
      const times = [TimeOfDay(hour: 10, minute: 0)];
      const state = NotificationSettingsState(times: times, isLoading: false);
      final updated = state.copyWith();

      expect(updated.times, times);
      expect(updated.isLoading, isFalse);
    });
  });
}
