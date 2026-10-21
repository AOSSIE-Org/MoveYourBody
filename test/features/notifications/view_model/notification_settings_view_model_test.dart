import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/features/notifications/repositories/notification_repository.dart';
import 'package:move_your_body/features/notifications/services/notification_service.dart';
import 'package:move_your_body/features/notifications/view_model/notification_settings_view_model.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockNotificationRepository mockRepo;
  late MockNotificationService mockService;
  late ProviderContainer container;
  late ProviderSubscription subscription;

  setUp(() {
    mockRepo = MockNotificationRepository();
    mockService = MockNotificationService();

    when(() => mockService.init()).thenAnswer((_) async {});
    when(() => mockService.requestPermissions()).thenAnswer((_) async {});
    when(() => mockRepo.getNotificationTimes()).thenAnswer(
      (_) async => [const TimeOfDay(hour: 9, minute: 0)],
    );
    when(() => mockRepo.saveNotificationTimes(any())).thenAnswer((_) async {});
    when(() => mockService.scheduleDailyNotifications(any())).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        notificationRepositoryProvider.overrideWithValue(mockRepo),
        notificationServiceProvider.overrideWithValue(mockService),
      ],
    );

    subscription = container.listen(
      notificationSettingsViewModelProvider,
      (_, __) {},
    );
  });

  tearDown(() {
    subscription.close();
    container.dispose();
  });

  group('NotificationSettingsViewModel Tests', () {
    test('initial state and _initialize loads times successfully', () async {
      expect(subscription.read().isLoading, isTrue);

      await Future.delayed(const Duration(milliseconds: 50));

      final state = subscription.read();
      expect(state.isLoading, isFalse);
      expect(state.times.length, 1);
      expect(state.times.first, const TimeOfDay(hour: 9, minute: 0));

      verify(() => mockService.init()).called(1);
      verify(() => mockService.requestPermissions()).called(1);
      verify(() => mockRepo.getNotificationTimes()).called(1);
    });

    test('addTime appends time in sorted order and saves & schedules', () async {
      final notifier = container.read(notificationSettingsViewModelProvider.notifier);
      await Future.delayed(const Duration(milliseconds: 50));

      await notifier.addTime(const TimeOfDay(hour: 7, minute: 30));

      final state = subscription.read();
      expect(state.times.length, 2);
      expect(state.times[0], const TimeOfDay(hour: 7, minute: 30));
      expect(state.times[1], const TimeOfDay(hour: 9, minute: 0));

      verify(() => mockRepo.saveNotificationTimes(state.times)).called(1);
      verify(() => mockService.scheduleDailyNotifications(state.times)).called(1);
    });

    test('addTime ignores duplicate times', () async {
      final notifier = container.read(notificationSettingsViewModelProvider.notifier);
      await Future.delayed(const Duration(milliseconds: 50));

      await notifier.addTime(const TimeOfDay(hour: 9, minute: 0));

      final state = subscription.read();
      expect(state.times.length, 1);

      verifyNever(() => mockRepo.saveNotificationTimes(any()));
    });

    test('removeTime deletes specified time and saves & schedules', () async {
      final notifier = container.read(notificationSettingsViewModelProvider.notifier);
      await Future.delayed(const Duration(milliseconds: 50));

      await notifier.removeTime(const TimeOfDay(hour: 9, minute: 0));

      final state = subscription.read();
      expect(state.times, isEmpty);

      verify(() => mockRepo.saveNotificationTimes([])).called(1);
      verify(() => mockService.scheduleDailyNotifications([])).called(1);
    });
  });
}
