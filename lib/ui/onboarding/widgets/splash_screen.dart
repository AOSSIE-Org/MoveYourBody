import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/data/database/db_config.dart';
import 'package:move_your_body/data/repositories/user_repository.dart';
import 'package:move_your_body/routing/app_routes.dart';
import 'package:move_your_body/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:move_your_body/utils/constants/app_constants.dart';
import 'package:move_your_body/utils/theme/app_themes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: AppConstants.splashFadeDuration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final results = await Future.wait([
      _loadInitialData(),
      Future.delayed(AppConstants.splashDuration),
    ]);

    if (!mounted) return;

    final targetRoute = results[0] as String;
    try {
      context.go(targetRoute);
    } catch (e) {
      debugPrint('Navigation failed or GoRouter not present: $e');
    }
  }

  Future<String> _loadInitialData() async {
    try {
      final user = await ref.read(userRepositoryProvider).getUserData();
      await ref.read(databaseServiceProvider).exercisesDatabase;
      if (user != null) {
        ref.read(onboardingViewModelProvider.notifier).loadFromUserData(user);
      }
      return user?.isOnboarded == true ? AppRoutes.home : AppRoutes.welcome;
    } catch (e) {
      debugPrint('Error loading initial data: $e');
      return AppRoutes.welcome;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: const _SplashBrandRow(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashBrandRow extends StatelessWidget {
  const _SplashBrandRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _LogoBox(assetPath: AppAssets.appLogo),
            SizedBox(width: 14),
            _BrandDivider(),
            SizedBox(width: 14),
            _LogoBox(assetPath: AppAssets.aossieLogo),
          ],
        ),
      ),
    );
  }
}

class _LogoBox extends StatelessWidget {
  final String assetPath;

  const _LogoBox({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Image.asset(assetPath, fit: BoxFit.contain),
    );
  }
}

class _BrandDivider extends StatelessWidget {
  const _BrandDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 70,
      width: 16,
      child: VerticalDivider(width: 16, thickness: 1.2, color: Colors.grey),
    );
  }
}
