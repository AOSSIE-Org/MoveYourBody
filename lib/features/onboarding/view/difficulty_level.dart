import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_flutter/core/widgets/button_card.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class DifficultyScreen extends ConsumerWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final selectedDifficulty = ref.watch(
      onboardingProvider.select((state) => state.difficulty),
    );

    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return AppScaffold(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Progress
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
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
              selected: selectedDifficulty == 'Beginner',
              onTap: () {
                onboardingNotifier.setDifficulty('Beginner');
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Intermediate',
              subtitle:
                  'Exercise regularly and have a basic fitness foundation.',
              selected: selectedDifficulty == 'Intermediate',
              onTap: () {
                onboardingNotifier.setDifficulty('Intermediate');
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Advanced',
              subtitle:
                  'Train consistently with strong endurance and strength.',
              selected: selectedDifficulty == 'Advanced',
              onTap: () {
                onboardingNotifier.setDifficulty('Advanced');
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/onboarding/intensity');
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
