import 'package:flutter/material.dart';
import 'package:move_your_body/core/widgets/onboarding_progress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/widgets/button_card.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class IntensityScreen extends ConsumerWidget {
  const IntensityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final selectedIntensity = ref.watch(
      onboardingViewModelProvider.select((state) => state.intensity),
    );

    final onboardingNotifier = ref.read(onboardingViewModelProvider.notifier);

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Progress
            const OnboardingProgress(currentStep: 3),

            const SizedBox(height: 10),

            Text(
              'Choose your Intensity Level',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Light',
              subtitle:
                  'Easy-paced workouts focused on mobility, consistency, and recovery.',
              selected: selectedIntensity == Intensity.low.name,
              onTap: () {
                onboardingNotifier.setIntensity(Intensity.low.name);
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Moderate',
              subtitle:
                  'Balanced challenge to improve endurance, fitness and strength.',
              selected: selectedIntensity == Intensity.moderate.name,
              onTap: () {
                onboardingNotifier.setIntensity(Intensity.moderate.name);
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'High',
              subtitle:
                  'Demanding sessions designed to maximize performance and results.',
              selected: selectedIntensity == Intensity.high.name,
              onTap: () {
                onboardingNotifier.setIntensity(Intensity.high.name);
              },
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push(AppRoutes.targetBodyRegion);
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
