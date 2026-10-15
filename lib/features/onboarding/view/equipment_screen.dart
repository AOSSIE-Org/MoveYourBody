import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/widgets/button_card.dart';
import 'package:move_your_body/core/widgets/onboarding_progress.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class EquipmentScreen extends ConsumerWidget {
  const EquipmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final selectedEquipments = ref.watch(
      onboardingViewModelProvider.select((state) => state.equipments),
    );

    final onboardingNotifier = ref.read(onboardingViewModelProvider.notifier);

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
                selected: selectedEquipments.contains('Yoga Mat'),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment('Yoga Mat');
                },
              ),
              const SizedBox(height: 20),

              ButtonCard(
                title: 'Dumbbells',
                selected: selectedEquipments.contains('Dumbbells'),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment('Dumbbells');
                },
              ),

              const SizedBox(height: 20),

              ButtonCard(
                title: 'Resistance Bands',
                selected: selectedEquipments.contains('Resistance Bands'),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment('Resistance Bands');
                },
              ),

              const SizedBox(height: 20),

              ButtonCard(
                title: 'Pull-Up Bar',
                selected: selectedEquipments.contains('Pull-Up Bar'),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment('Pull-Up Bar');
                },
              ),

              const SizedBox(height: 20),
              ButtonCard(
                title: 'Yoga Blocks and Belts ',
                selected: selectedEquipments.contains('Yoga Blocks and Belts '),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment('Yoga Blocks and Belts ');
                },
              ),

              const SizedBox(height: 20),
              ButtonCard(
                title: 'Exercise Bench',
                selected: selectedEquipments.contains('Exercise Bench'),
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
                    context.push(AppRoutes.userData);
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
