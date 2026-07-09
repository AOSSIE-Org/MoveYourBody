import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/model/tag_data.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/features/ai_inference/repositories/ai_repository.dart';
import 'package:move_your_body/features/ai_inference/repositories/tag_setup_repository.dart';
import 'package:move_your_body/features/ai_inference/view_model/ai_inference_view_model.dart';
import 'package:move_your_body/features/onboarding/repository/user_repository.dart';
import 'package:move_your_body/features/onboarding/view_model/onboarding_view_model.dart';
import '../../../../core/theme/app_colors.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _executeMasterPipeline();
  }

  Future<void> _executeMasterPipeline() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final aiModelRepo = ref.read(aiModelRepositoryProvider);
      final tagSetupRepo = ref.read(tagSetupRepositoryProvider);
      final onboardingData = ref.read(onboardingViewModelProvider);

      print("🚀 Pipeline Phase 1: Initializing ONNX Engine...");
      await aiModelRepo.initModel();

      print("🚀 Pipeline Phase 2: Syncing Static JSON Tags to DB...");
      await tagSetupRepo.processAndSeedTags();

      Uint8List? customGoalBytes;
      Uint8List? customHealthBytes;

      if (onboardingData.customGoal.trim().isNotEmpty) {
        print(
          "🧠 Pipeline Phase 3: Generating embedding for Custom Goal: '${onboardingData.customGoal}'",
        );
        customGoalBytes = await aiModelRepo.generateEmbedding(
          onboardingData.customGoal.trim(),
        );
      }

      if (onboardingData.customHealthIssue.trim().isNotEmpty) {
        print(
          "🧠 Pipeline Phase 4: Generating embedding for Custom Injury: '${onboardingData.customHealthIssue}'",
        );
        customHealthBytes = await aiModelRepo.generateEmbedding(
          onboardingData.customHealthIssue.trim(),
        );
      }
      final goalMatches = await tagSetupRepo.findTopMatches(
        type: TagType.goal,
        userEmbedding: customGoalBytes,
        limit: 3,
        threshold: 0.60,
      );
      final healthMatches = await tagSetupRepo.findTopMatches(
        type: TagType.injury,
        userEmbedding: customHealthBytes,
        limit: 3,
        threshold: 0.60,
      );
      await ref
          .read(onboardingViewModelProvider.notifier)
          .saveAndCompleteOnboarding(
            goalEmbed: customGoalBytes,
            healthEmbed: customHealthBytes,
          );

      await ref
          .read(tagSetupRepositoryProvider)
          .updateResolvedTags(goals: goalMatches, injuries: healthMatches);
      ref
          .read(onboardingViewModelProvider.notifier)
          .updateResolvedTags(goals: goalMatches, healthIssues: healthMatches);
      await ref.read(userRepositoryProvider).debugPrintUserData();
      print(
        "💾 Pipeline Phase 5: Saving complete profile to UserTable and extracting top tags.",
      );

      ref.read(aiInferenceViewModelProvider.notifier).setEngineReady();

      if (!mounted) return;

      print(
        "🎯 Pipeline Perfect: All operations complete. Redirecting to Results.",
      );
      context.go(AppRoutes.result);
    } catch (e) {
      print("❌ Critical Pipeline Crash: $e");
      if (mounted) context.go(AppRoutes.result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.divider, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 4.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                          backgroundColor: AppColors.card,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Text(
                        'Personalizing Your Plan',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Our local AI model is executing secure mathematical vector inferences on your profile parameters to finalize custom exercise routines natively.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.security_rounded,
                        color: AppColors.primaryLight,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '100% Secure Local Execution',
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.primaryLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
