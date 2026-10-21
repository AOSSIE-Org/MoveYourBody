import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:move_your_body/features/notifications/repositories/notification_repository.dart';

void main() {
  group('NotificationRepository Tests', () {
    late NotificationRepository repository;

    setUp(() {
      repository = NotificationRepository();
    });

    test(
      'getNotificationTimes returns empty list when no data is saved',
      () async {
        SharedPreferences.setMockInitialValues({});

        final result = await repository.getNotificationTimes();

        expect(result, isEmpty);
      },
    );

    test('getNotificationTimes correctly parses stored time strings', () async {
      SharedPreferences.setMockInitialValues({
        'notification_times': ['08:30', '19:45'],
      });

      final result = await repository.getNotificationTimes();

      expect(result.length, 2);
      expect(result[0].hour, 8);
      expect(result[0].minute, 30);
      expect(result[1].hour, 19);
      expect(result[1].minute, 45);
    });

    test(
      'getNotificationTimes falls back to default time for malformed format',
      () async {
        SharedPreferences.setMockInitialValues({
          'notification_times': ['invalid', 'not:a_number'],
        });

        final result = await repository.getNotificationTimes();

        expect(result.length, 2);
        expect(result[0].hour, 9);
        expect(result[0].minute, 0);
        expect(result[1].hour, 9);
        expect(result[1].minute, 0);
      },
    );

    test(
      'saveNotificationTimes formats and persists times with two-digit padding',
      () async {
        SharedPreferences.setMockInitialValues({});

        const times = [
          TimeOfDay(hour: 7, minute: 5),
          TimeOfDay(hour: 21, minute: 40),
        ];

        await repository.saveNotificationTimes(times);

        final prefs = await SharedPreferences.getInstance();
        final savedStrings = prefs.getStringList('notification_times');

        expect(savedStrings, isNotNull);
        expect(savedStrings, ['07:05', '21:40']);
      },
    );
  });
}