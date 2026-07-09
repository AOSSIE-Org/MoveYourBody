import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/widgets/button_card.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class DifficultyScreen extends ConsumerWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final selectedDifficulty = ref.watch(
      onboardingViewModelProvider.select((state) => state.difficulty),
    );

    final onboardingNotifier = ref.read(onboardingViewModelProvider.notifier);

    return AppScaffold(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Progress
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      6,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == 2
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
              'Choose your Difficulty Level',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Beginner',
              subtitle:
                  'New to fitness, rarely exercise or returning after a long break.',
              selected: selectedDifficulty == Difficulty.beginner.name,
              onTap: () {
                onboardingNotifier.setDifficulty(Difficulty.beginner.name);
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Intermediate',
              subtitle:
                  'Exercise regularly and have a basic fitness foundation.',
              selected: selectedDifficulty == Difficulty.intermediate.name,
              onTap: () {
                onboardingNotifier.setDifficulty(Difficulty.intermediate.name);
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Advanced',
              subtitle:
                  'Train consistently with strong endurance and strength.',
              selected: selectedDifficulty == Difficulty.advanced.name,
              onTap: () {
                onboardingNotifier.setDifficulty(Difficulty.advanced.name);
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push(AppRoutes.intensity);
                },
                child: const Text('Continue'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
