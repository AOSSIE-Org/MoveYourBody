import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_flutter/core/widgets/button_card.dart';
import 'package:template_flutter/core/widgets/onboarding_progress.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class EquipmentScreen extends ConsumerWidget {
  const EquipmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final onboardingState = ref.watch(onboardingProvider);

    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return AppScaffold(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const OnboardingProgress(currentStep: 5),
              const SizedBox(height: 10),

              Text(
                'What equipment do you have access to?',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),
              ButtonCard(
                title: 'Yoga Mat',
                selected: onboardingState.equipments.contains('Yoga Mat'),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment('Yoga Mat');
                },
              ),
              const SizedBox(height: 20),

              ButtonCard(
                title: 'Dumbbells',
                selected: onboardingState.equipments.contains('Dumbbells'),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment('Dumbbells');
                },
              ),

              const SizedBox(height: 20),

              ButtonCard(
                title: 'Resistance Bands',
                selected: onboardingState.equipments.contains(
                  'Resistance Bands',
                ),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment('Resistance Bands');
                },
              ),

              const SizedBox(height: 20),

              ButtonCard(
                title: 'Pull-Up Bar',
                selected: onboardingState.equipments.contains('Pull-Up Bar'),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment('Pull-Up Bar');
                },
              ),

              const SizedBox(height: 20),
              ButtonCard(
                title: 'Yoga Blocks and Belts ',
                selected: onboardingState.equipments.contains(
                  'Yoga Blocks and Belts ',
                ),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment('Yoga Blocks and Belts ');
                },
              ),

              const SizedBox(height: 20),
              ButtonCard(
                title: 'Exercise Bench',
                selected: onboardingState.equipments.contains('Exercise Bench'),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment('Exercise Bench');
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/onboarding/userdata');
                  },
                  child: const Text('Continue'),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
