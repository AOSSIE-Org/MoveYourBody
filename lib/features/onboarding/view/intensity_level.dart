import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_flutter/core/widgets/app_toast.dart';
import 'package:template_flutter/core/widgets/button_card.dart';
import 'package:template_flutter/core/widgets/onboarding_progress.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class IntensityScreen extends ConsumerWidget {
  const IntensityScreen({super.key});

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
              selected: onboardingState.intensity == 'Light',
              onTap: () {
                onboardingNotifier.setIntensity('Light');
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Moderate',
              subtitle:
                  'Balanced challenge to improve endurance, fitness and strength.',
              selected: onboardingState.intensity == 'Moderate',
              onTap: () {
                onboardingNotifier.setIntensity('Moderate');
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'High',
              subtitle:
                  'Demanding sessions designed to maximize performance and results.',
              selected: onboardingState.intensity == 'High',
              onTap: () {
                onboardingNotifier.setIntensity('High');
              },
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (onboardingState.intensity == null) {
                    AppToast.show(context, 'Please select an intensity level');
                    return;
                  } else {
                    Navigator.of(
                      context,
                    ).pushNamed('/onboarding/target-body-region');
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
