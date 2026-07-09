import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/service/seed_service.dart';
import '../repository/user_repository.dart';
import '../view_model/onboarding_view_model.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    final user = await ref.read(userRepositoryProvider).getUserData();
    await SeedService().seedExercises();
    // await SeedService().debugPrintExercises();
    if (user != null) {
      print("-------------------");
      ref.read(onboardingViewModelProvider.notifier).loadFromUserData(user);
    }

    if (!mounted) return;

    final targetRoute = user?.isOnboarded == true
        ? AppRoutes.result
        : AppRoutes.welcome;

    context.go(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
