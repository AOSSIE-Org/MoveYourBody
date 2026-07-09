import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_flutter/core/widgets/app_toast.dart';
import 'package:template_flutter/core/widgets/button_card.dart';
import 'package:template_flutter/core/widgets/onboarding_progress.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class DifficultyScreen extends ConsumerWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final onboardingState = ref.watch(onboardingProvider);

    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return AppScaffold(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const OnboardingProgress(currentStep: 2),
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
              selected: onboardingState.difficulty == 'Beginner',
              onTap: () {
                onboardingNotifier.setDifficulty('Beginner');
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Intermediate',
              subtitle:
                  'Exercise regularly and have a basic fitness foundation.',
              selected: onboardingState.difficulty == 'Intermediate',
              onTap: () {
                onboardingNotifier.setDifficulty('Intermediate');
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Advanced',
              subtitle:
                  'Train consistently with strong endurance and strength.',
              selected: onboardingState.difficulty == 'Advanced',
              onTap: () {
                onboardingNotifier.setDifficulty('Advanced');
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (onboardingState.difficulty == null) {
                    AppToast.show(context, 'Please select a difficulty level');
                    return;
                  } else {
                    Navigator.pushNamed(context, '/onboarding/intensity');
                  }
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
