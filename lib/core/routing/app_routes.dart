class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/onboarding/welcome';
  static const String goals = '/onboarding/goals';
  static const String healthIssues = '/onboarding/health-issues';
  static const String difficulty = '/onboarding/difficulty';
  static const String intensity = '/onboarding/intensity';
  static const String targetBodyRegion = '/onboarding/target-body-region';
  static const String equipments = '/onboarding/equipments';
  static const String userData = '/onboarding/userdata';
  static const String loading = '/loading';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String add = '/add';
  static const String stats = '/stats';
  static const String profile = '/profile';
  static const String sessiondetails = '/session-details/:sessionId';
  static const String exerciseInfo = '/exercise-info/:exerciseId';
  static const String sessionExecution = '/session-execution/:sessionId';
  static const String postsessionfeedback = '/post-session-feedback/:sessionId';
  static const String search = '/search';
  static const String pastSessionDetails = '/past-session-details/:sessionId';
  static const String allSessions = '/all-sessions';

  static String sessionDetailsPath(int sessionId) =>
      '/session-details/$sessionId';

  static String exerciseInfoPath(String exerciseId) =>
      '/exercise-info/$exerciseId';

  static String sessionExecutionPath(int sessionId) =>
      '/session-execution/$sessionId';

  static String postSessionFeedbackPath(int sessionId) =>
      '/post-session-feedback/$sessionId';

  static String pastSessionDetailsPath(int sessionId) =>
      '/past-session-details/$sessionId';
}
