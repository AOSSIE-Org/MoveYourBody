import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_flutter/core/widgets/app_toast.dart';
import 'package:template_flutter/core/widgets/button_card.dart';
import 'package:template_flutter/core/widgets/onboarding_progress.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class BodyRegionScreen extends ConsumerWidget {
  const BodyRegionScreen({super.key});

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
            const OnboardingProgress(currentStep: 4),
            const SizedBox(height: 10),

            Text(
              'What would you like to focus on most?',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),
            ButtonCard(
              title: 'Cardio and Endurance',
              selected: onboardingState.targetbodyRegion.contains(
                'Cardio and Endurance',
              ),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion(
                  'Cardio and Endurance',
                );
              },
            ),
            const SizedBox(height: 20),

            ButtonCard(
              title: 'Upper Body',
              selected: onboardingState.targetbodyRegion.contains('Upper Body'),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion('Upper Body');
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Core Strength',
              selected: onboardingState.targetbodyRegion.contains(
                'Core Strength',
              ),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion('Core Strength');
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Lower Body',
              selected: onboardingState.targetbodyRegion.contains('Lower Body'),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion('Lower Body');
              },
            ),

            const SizedBox(height: 20),
            ButtonCard(
              title: 'Mobility and Flexibility',
              selected: onboardingState.targetbodyRegion.contains(
                'Mobility and Flexibility',
              ),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion(
                  'Mobility and Flexibility',
                );
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (onboardingState.targetbodyRegion.isEmpty) {
                    AppToast.show(
                      context,
                      'Please select atleast one target body region',
                    );
                    return;
                  } else {
                    Navigator.pushNamed(context, '/onboarding/equipments');
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
