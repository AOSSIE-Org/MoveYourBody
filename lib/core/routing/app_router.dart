import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/widgets/loading_screen.dart';
import 'package:move_your_body/features/onboarding/view/splash_screen.dart';
import './app_routes.dart';
import '../../features/onboarding/view/body_region_screen.dart';
import '../../features/onboarding/view/difficulty_level.dart';
import '../../features/onboarding/view/equipment_screen.dart';
import '../../features/onboarding/view/goal_screen.dart';
import '../../features/onboarding/view/health_issues.dart';
import '../../features/onboarding/view/intensity_level.dart';
import '../../features/onboarding/view/resultscreen.dart';
import '../../features/onboarding/view/user_details.dart';
import '../../features/onboarding/view/welcome_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
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
      builder: (context, state) => const HealthIssuesScreen(),
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
      builder: (context, state) => const UserdataScreen(),
    ),
    GoRoute(
      path: AppRoutes.result,
      builder: (context, state) => const ResultScreen(),
    ),
    GoRoute(
      path: AppRoutes.loading,
      builder: (context, state) => const LoadingScreen(),
    ),
  ],
);
