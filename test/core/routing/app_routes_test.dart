import 'package:flutter_test/flutter_test.dart';
import 'package:move_your_body/routing/app_routes.dart';

void main() {
  group('AppRoutes Tests', () {
    test('static constants have correct path values', () {
      expect(AppRoutes.splash, '/');
      expect(AppRoutes.home, '/home');
      expect(AppRoutes.welcome, '/onboarding/welcome');
      expect(AppRoutes.stats, '/stats');
      expect(AppRoutes.profile, '/profile');
      expect(AppRoutes.search, '/search');
      expect(AppRoutes.allSessions, '/all-sessions');
    });

    test('helper methods construct valid dynamic paths', () {
      expect(AppRoutes.sessionDetailsPath(42), '/session-details/42');
      expect(AppRoutes.exerciseInfoPath('pushup_1'), '/exercise-info/pushup_1');
      expect(AppRoutes.sessionExecutionPath(12), '/session-execution/12');
      expect(AppRoutes.postSessionFeedbackPath(8), '/post-session-feedback/8');
      expect(AppRoutes.pastSessionDetailsPath(99), '/past-session-details/99');
    });
  });
}
