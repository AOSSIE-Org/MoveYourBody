import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/widgets/custom_bottom_navbar.dart';
import 'package:move_your_body/core/widgets/loading_screen.dart';
import 'package:move_your_body/features/home/screens/home_screen.dart';
import 'package:move_your_body/features/home/screens/session_details_screen.dart';
import 'package:move_your_body/features/home/screens/exercise_info_screen.dart';
import 'package:move_your_body/features/home/screens/session_execution_screen.dart';
import 'package:move_your_body/features/home/screens/session_feedback_screen.dart';
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
      path: AppRoutes.loading,
      builder: (context, state) => const LoadingScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(child: navigationShell),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomBottomNavBar(navigationShell: navigationShell),
              ),
            ],
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.explore,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Explore'))),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.add,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Add Workout'))),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.stats,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Stats'))),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ResultScreen(),
            ),
          ],
        ),
      ],
    ),
    
    GoRoute(
      path: AppRoutes.sessiondetails,
      builder: (context, state) {
        final sessionId = int.parse(
          state.pathParameters['sessionId']!,
        );
        return SessionDetailsScreen(sessionId: sessionId);
      },
    ),

    GoRoute(
      path: AppRoutes.exerciseInfo,
      builder: (context, state) {
        final exerciseId = state.pathParameters['exerciseId']!;
        return ExerciseInfoScreen(exerciseId: exerciseId);
      },
    ),
    GoRoute(
      path: AppRoutes.sessionExecution,
      builder: (context, state) {
        final sessionId = int.parse(state.pathParameters['sessionId']!);
        return SessionExecutionScreen(sessionId: sessionId);
      },
    ),
    GoRoute(
      path: AppRoutes.postsessionfeedback,
      builder: (context, state) {
        final sessionId = int.parse(state.pathParameters['sessionId']!);
        return SessionFeedbackScreen(sessionId: sessionId);
      },
    ),
  ],
);
