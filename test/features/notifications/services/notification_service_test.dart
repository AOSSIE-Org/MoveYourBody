import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:move_your_body/data/services/notification_service.dart';

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class FakeNotificationDetails extends Fake implements NotificationDetails {}

class FakeTZDateTime extends Fake implements tz.TZDateTime {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));
    registerFallbackValue(FakeNotificationDetails());
    registerFallbackValue(FakeTZDateTime());
    registerFallbackValue(AndroidScheduleMode.exactAllowWhileIdle);
    registerFallbackValue(DateTimeComponents.time);
  });

  group('NotificationService Tests', () {
    late MockFlutterLocalNotificationsPlugin mockPlugin;
    late NotificationService service;

    setUp(() {
      mockPlugin = MockFlutterLocalNotificationsPlugin();
      service = NotificationService(plugin: mockPlugin);
    });

    test(
      'notificationServiceProvider provides NotificationService instance',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final instance = container.read(notificationServiceProvider);
        expect(instance, isA<NotificationService>());
      },
    );

    test('isInitialized is initially false', () {
      expect(service.isInitialized, isFalse);
    });

    test(
      'scheduleDailyNotifications with empty list calls cancelAll and returns',
      () async {
        when(() => mockPlugin.cancelAll()).thenAnswer((_) async {});

        await service.scheduleDailyNotifications([]);

        verify(() => mockPlugin.cancelAll()).called(1);
        verifyNever(
          () => mockPlugin.zonedSchedule(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          ),
        );
      },
    );

    test('scheduleDailyNotifications with times schedules each time', () async {
      when(() => mockPlugin.cancelAll()).thenAnswer((_) async {});
      when(
        () => mockPlugin.zonedSchedule(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledDate: any(named: 'scheduledDate'),
          notificationDetails: any(named: 'notificationDetails'),
          androidScheduleMode: any(named: 'androidScheduleMode'),
          matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
        ),
      ).thenAnswer((_) async {});

      final times = [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 18, minute: 30),
      ];

      await service.scheduleDailyNotifications(times);

      verify(() => mockPlugin.cancelAll()).called(1);
      verify(
        () => mockPlugin.zonedSchedule(
          id: 0,
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledDate: any(named: 'scheduledDate'),
          notificationDetails: any(named: 'notificationDetails'),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        ),
      ).called(1);
      verify(
        () => mockPlugin.zonedSchedule(
          id: 1,
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledDate: any(named: 'scheduledDate'),
          notificationDetails: any(named: 'notificationDetails'),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        ),
      ).called(1);
    });
  });
}
