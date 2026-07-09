import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_flutter/core/service/seed_service.dart';

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
    final user = await UserRepository().getUserData();
    await SeedService().seedExercises();
    // await SeedService().debugPrintExercises();

    if (user != null) {
      ref.read(onboardingProvider.notifier).loadFromUserData(user);
    }

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      user?.isOnboarded == true ? '/onboarding/result' : '/onboarding/welcome',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
