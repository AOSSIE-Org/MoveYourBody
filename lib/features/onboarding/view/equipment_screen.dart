import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/widgets/button_card.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class EquipmentScreen extends ConsumerWidget {
  const EquipmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
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
                'What equipment do you have access to?',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),
              ButtonCard(
                title: 'Yoga Mat',
                selected: selectedEquipments.contains(Equipment.yogaMat.name),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment(Equipment.yogaMat.name);
                },
              ),
              const SizedBox(height: 20),

              ButtonCard(
                title: 'Dumbbells',
                selected: selectedEquipments.contains(Equipment.dumbbells.name),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment(Equipment.dumbbells.name);
                },
              ),
              const SizedBox(height: 20),

              ButtonCard(
                title: 'Pull-Up Bar',
                selected: selectedEquipments.contains(Equipment.pullUpBar.name),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment(Equipment.pullUpBar.name);
                },
              ),

              const SizedBox(height: 20),
              ButtonCard(
                title: 'Stability Ball',
                selected: selectedEquipments.contains(
                  Equipment.stabilityBall.name,
                ),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment(
                    Equipment.stabilityBall.name,
                  );
                },
              ),

              const SizedBox(height: 20),
              ButtonCard(
                title: 'Jump Rope',
                selected: selectedEquipments.contains(Equipment.jumpRope.name),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment(Equipment.jumpRope.name);
                },
              ),

              const SizedBox(height: 20),
              ButtonCard(
                title: 'Exercise Bench',
                selected: selectedEquipments.contains(Equipment.bench.name),
                titleFontSize: 20,
                onTap: () {
                  onboardingNotifier.toggleEquipment(Equipment.bench.name);
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
