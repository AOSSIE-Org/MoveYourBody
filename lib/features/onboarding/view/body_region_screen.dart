import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
              selected: selectedBodyRegions.contains('Cardio and Endurance'),
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
              selected: selectedBodyRegions.contains('Upper Body'),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion('Upper Body');
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Core Strength',
              selected: selectedBodyRegions.contains('Core Strength'),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion('Core Strength');
              },
            ),

            const SizedBox(height: 20),

            ButtonCard(
              title: 'Lower Body',
              selected: selectedBodyRegions.contains('Lower Body'),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion('Lower Body');
              },
            ),

            const SizedBox(height: 20),
            ButtonCard(
              title: 'Mobility and Flexibility',
              selected: selectedBodyRegions.contains(
                'Mobility and Flexibility',
              ),
              titleFontSize: 20,
              onTap: () {
                onboardingNotifier.toggleTargetBodyRegion(
                  'Mobility and Flexibility',
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
