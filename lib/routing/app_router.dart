import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import '../ui/onboarding/widgets/body_region_screen.dart';
import '../ui/onboarding/widgets/difficulty_level.dart';
import '../ui/onboarding/widgets/equipment_screen.dart';
import '../ui/onboarding/widgets/goal_screen.dart';
import '../ui/onboarding/widgets/health_issues.dart';
import '../ui/onboarding/widgets/intensity_level.dart';
import '../ui/onboarding/widgets/resultscreen.dart';
import '../ui/onboarding/widgets/user_details.dart';
import '../ui/onboarding/widgets/welcome_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.welcome,
  routes: [
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.goals,
      builder: (context, state) => const GoalScreen(),
    ),
    GoRoute(
      path: AppRoutes.healthIssues,
      builder: (context, state) =>
          const HealthIssuesScreen(),
    ),
    GoRoute(
      path: AppRoutes.difficulty,
      builder: (context, state) => const DifficultyScreen(),
    ),
    GoRoute(
      path: AppRoutes.intensity,
      builder: (context, state) => const IntensityScreen(),
    ),
    GoRoute(
      path: AppRoutes.targetBodyRegion,
      builder: (context, state) => const BodyRegionScreen(),
    ),
    GoRoute(
      path: AppRoutes.equipments,
      builder: (context, state) => const EquipmentScreen(),
    ),
    GoRoute(
      path: AppRoutes.userData,
      builder: (context, state) =>
          const UserdataScreen(),
    ),
    GoRoute(
      path: AppRoutes.result,
      builder: (context, state) => const ResultScreen(),
    ),
  ],
);
