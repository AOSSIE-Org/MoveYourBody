import 'package:flutter/material.dart';
import 'package:template_flutter/features/onboarding/view/body_region_screen.dart';
import 'package:template_flutter/features/onboarding/view/difficulty_level.dart';
import 'package:template_flutter/features/onboarding/view/equipment_screen.dart';
import 'package:template_flutter/features/onboarding/view/goal_screen.dart';
import 'package:template_flutter/features/onboarding/view/health_issues.dart';
import 'package:template_flutter/features/onboarding/view/intensity_level.dart';
import 'package:template_flutter/features/onboarding/view/resultscreen.dart';
import 'package:template_flutter/features/onboarding/view/splash_screen.dart';
import 'package:template_flutter/features/onboarding/view/user_details.dart';

import 'core/theme/app_themes.dart';
import 'features/onboarding/view/welcome_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding/welcome': (context) => const WelcomeScreen(),
        '/onboarding/goals': (context) => const GoalScreen(),
        '/onboarding/health-issues': (context) => const HealthIssuesScreen(),
        '/onboarding/difficulty': (context) => const DifficultyScreen(),
        '/onboarding/intensity': (context) => const IntensityScreen(),
        '/onboarding/target-body-region': (context) => const BodyRegionScreen(),
        '/onboarding/equipments': (context) => const EquipmentScreen(),
        '/onboarding/userdata': (context) => const UserdataScreen(),
        '/onboarding/result': (context) => const ResultScreen(),
      },
    );
  }
}
