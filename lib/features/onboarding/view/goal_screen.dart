import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/features/onboarding/view_model/onboarding_view_model.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/feature_chip.dart';
import 'package:go_router/go_router.dart';

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
    final onboardingNotifier = ref.read(onboardingViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  tooltip: 'Go back',
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      6,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == 0 ? 8 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == 0
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

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
