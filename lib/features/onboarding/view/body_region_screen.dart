import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/widgets/button_card.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class BodyRegionScreen extends ConsumerWidget {
  const BodyRegionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final selectedBodyRegions = ref.watch(
      onboardingViewModelProvider.select((state) => state.targetBodyRegion),
    );

    final onboardingNotifier = ref.read(onboardingViewModelProvider.notifier);

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
              'What would you like to focus on most?',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),
            ButtonCard(
              title: 'Cardio and Endurance',
              selected: selectedBodyRegions.contains(BodyRegion.cardioAndEndurance.name),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion(
                  BodyRegion.cardioAndEndurance.name,
                );
              },
            ),
            const SizedBox(height: 20),

            ButtonCard(
              title: 'Upper Body',
              selected: selectedBodyRegions.contains(BodyRegion.upperBody.name),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion(BodyRegion.upperBody.name);
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Core Strength',
              selected: selectedBodyRegions.contains(BodyRegion.core.name),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion(BodyRegion.core.name);
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Lower Body',
              selected: selectedBodyRegions.contains(BodyRegion.lowerBody.name),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion(BodyRegion.lowerBody.name);
              },
            ),

            const SizedBox(height: 20),
            ButtonCard(
              title: 'Mobility and Flexibility',
              selected: selectedBodyRegions.contains(
                BodyRegion.mobilityAndFlexibility.name,
              ),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion(
                  BodyRegion.mobilityAndFlexibility.name,
                );
              },
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push(AppRoutes.equipments);
                },
                child: const Text('Continue'),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
