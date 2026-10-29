import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/ui/common/custom_bottom_navbar.dart';
import 'package:move_your_body/ui/common/loading_screen.dart';
import 'package:move_your_body/ui/home/widgets/screens/home_screen.dart';
import 'package:move_your_body/ui/home/widgets/screens/session_details_screen.dart';
import 'package:move_your_body/ui/home/widgets/screens/exercise_info_screen.dart';
import 'package:move_your_body/ui/home/widgets/screens/session_execution_screen.dart';
import 'package:move_your_body/ui/home/widgets/screens/session_feedback_screen.dart';
import 'package:move_your_body/ui/onboarding/widgets/difficulty_level.dart';
import 'package:move_your_body/ui/onboarding/widgets/splash_screen.dart';
import 'package:move_your_body/routing/app_routes.dart';
import 'package:move_your_body/ui/onboarding/widgets/welcome_screen.dart';
import 'package:move_your_body/ui/onboarding/widgets/goal_screen.dart';
import 'package:move_your_body/ui/onboarding/widgets/equipment_screen.dart';
import 'package:move_your_body/ui/onboarding/widgets/body_region_screen.dart';
import 'package:move_your_body/ui/onboarding/widgets/health_issues.dart';
import 'package:move_your_body/ui/onboarding/widgets/intensity_level.dart';
import 'package:move_your_body/ui/onboarding/widgets/resultscreen.dart';
import 'package:move_your_body/ui/onboarding/widgets/user_details.dart';
import 'package:move_your_body/ui/home/widgets/screens/search_screen.dart';
import 'package:move_your_body/ui/stats/widgets/stats_screen.dart';
import 'package:move_your_body/ui/stats/widgets/past_session_details_screen.dart';
import 'package:move_your_body/ui/stats/widgets/all_sessions_screen.dart';
import 'package:move_your_body/ui/home/widgets/screens/add_workout_screen.dart';
import 'package:move_your_body/ui/home/widgets/screens/create_custom_plan_screen.dart';

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
    GoRoute(
      path: AppRoutes.search,
      builder: (context, state) => const SearchScreen(),
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
              path: AppRoutes.add,
              builder: (context, state) => const AddWorkoutScreen(),
              routes: [
                GoRoute(
                  path: 'create-custom-plan',
                  builder: (context, state) => const CreateCustomPlanScreen(),
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.stats,
              builder: (context, state) => const StatsScreen(),
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
        final sessionId = int.parse(state.pathParameters['sessionId']!);
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
    GoRoute(
      path: AppRoutes.pastSessionDetails,
      builder: (context, state) {
        final sessionId = int.parse(state.pathParameters['sessionId']!);
        return PastSessionDetailsScreen(sessionId: sessionId);
      },
    ),
    GoRoute(
      path: AppRoutes.allSessions,
      builder: (context, state) => const AllSessionsScreen(),
    ),
  ],
);
