import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/widgets/app_toast.dart';
import 'package:move_your_body/core/widgets/onboarding_progress.dart';
import 'package:move_your_body/features/onboarding/view_model/onboarding_view_model.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/feature_chip.dart';

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});
  static const Map<String, String> goalsMap = {
    'Burn Fat': 'fat_burn',
    'Increase Mobility': 'mobility',
    'Tone Body': 'toning',
    'Build Muscle': 'muscle_building',
    'Improve Endurance': 'endurance',
    'Cardio Fitness': 'cardio',
    'Better Posture': 'posture',
    'Reduce Stress': 'stress_relief',
    'Core Strength': 'core_strength',
    'Bodyweight Only': 'bodyweight',
    'Improve Balance': 'balance',
    'Warm Up': 'warmup',
    'Improve Strength': 'strength',
    'Rehabilitation': 'rehabilitation',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoals = ref.watch(
      onboardingViewModelProvider.select((state) => state.goalTags),
    );
    final customGoal = ref.watch(
      onboardingViewModelProvider.select((state) => state.customGoal),
    );
    final onboardingNotifier = ref.read(onboardingViewModelProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const OnboardingProgress(currentStep: 0),
            const SizedBox(height: 10),

            Text(
              'Choose Your Goals',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 25),

            /// GOAL CHIPS
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: goalsMap.entries.map((entry) {
                final uiText = entry.key;
                final dbTag = entry.value;
                final isSelected = selectedGoals.contains(dbTag);
                return FeatureChip(
                  text: uiText,
                  selected: isSelected,
                  onTap: () {
                    onboardingNotifier.toggleGoal(dbTag);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            TextField(
              onChanged: (value) {
                onboardingNotifier.updateCustomGoal(value);
              },
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Any custom fitness goals',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  if (selectedGoals.length < 3 && customGoal.trim().isEmpty) {
                    AppToast.show(
                      context,
                      'Select at least 3 goals or enter yours',
                    );
                    return;
                  }
                  context.push(AppRoutes.healthIssues);
                },
                child: const Text('Continue'),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
