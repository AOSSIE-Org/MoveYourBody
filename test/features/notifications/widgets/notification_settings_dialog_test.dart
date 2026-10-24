import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:move_your_body/data/repositories/notification_repository.dart';
import 'package:move_your_body/data/services/notification_service.dart';
import 'package:move_your_body/ui/notifications/widgets/notification_settings_dialog.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late MockNotificationRepository mockRepo;
  late MockNotificationService mockService;

  setUp(() {
    mockRepo = MockNotificationRepository();
    mockService = MockNotificationService();

    when(() => mockService.init()).thenAnswer((_) async {});
    when(() => mockService.requestPermissions()).thenAnswer((_) async {});
    when(() => mockRepo.getNotificationTimes()).thenAnswer((_) async => []);
    when(() => mockRepo.saveNotificationTimes(any())).thenAnswer((_) async {});
    when(
      () => mockService.scheduleDailyNotifications(any()),
    ).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        notificationRepositoryProvider.overrideWithValue(mockRepo),
        notificationServiceProvider.overrideWithValue(mockService),
      ],
      child: const MaterialApp(
        home: Scaffold(body: NotificationSettingsDialog()),
      ),
    );
  }

  group('NotificationSettingsDialog Tests', () {
    testWidgets(
      'renders dialog header and empty state when no reminders exist',
      (WidgetTester tester) async {
        when(() => mockRepo.getNotificationTimes()).thenAnswer((_) async => []);

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        expect(find.text('Daily Reminders'), findsOneWidget);
        expect(
          find.text('Set times for your daily workout notifications.'),
          findsOneWidget,
        );
        expect(find.text('No reminders set.'), findsOneWidget);
        expect(find.text('Add Reminder'), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      },
    );

    testWidgets('renders reminder items when times exist', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepo.getNotificationTimes(),
      ).thenAnswer((_) async => [const TimeOfDay(hour: 8, minute: 30)]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('No reminders set.'), findsNothing);
      expect(find.byIcon(Icons.access_time), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('tapping delete icon removes the reminder', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepo.getNotificationTimes(),
      ).thenAnswer((_) async => [const TimeOfDay(hour: 8, minute: 30)]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      verify(() => mockRepo.saveNotificationTimes([])).called(1);
      verify(() => mockService.scheduleDailyNotifications([])).called(1);
      expect(find.text('No reminders set.'), findsOneWidget);
    });

    testWidgets('tapping close icon pops dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notificationRepositoryProvider.overrideWithValue(mockRepo),
            notificationServiceProvider.overrideWithValue(mockService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => NotificationSettingsDialog.show(context),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationSettingsDialog), findsOneWidget);

      // Close dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationSettingsDialog), findsNothing);
    });
  });
}
