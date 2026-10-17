import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/widgets/app_toast.dart';
import 'package:move_your_body/core/widgets/onboarding_progress.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class UserdataScreen extends ConsumerWidget {
  const UserdataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingNotifier = ref.read(onboardingViewModelProvider.notifier);
    final onboardingState = ref.watch(onboardingViewModelProvider);
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const OnboardingProgress(currentStep: 6),
            const SizedBox(height: 10),

            Text(
              'Let\'s personalize your fitness journey',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              onChanged: onboardingNotifier.setUsername,
              decoration: InputDecoration(
                hintText: 'Your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              onChanged: (value) {
                final weight = double.tryParse(value);

                if (weight != null && weight > 0 && weight <= 500) {
                  onboardingNotifier.setWeight(weight);
                } else if (value.isEmpty) {
                  onboardingNotifier.setWeight(null);
                }
              },
              decoration: InputDecoration(
                hintText: 'Weight (kg)',
                helperText: '1 - 500 kg',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              onChanged: (value) {
                final height = double.tryParse(value);

                if (height != null && height > 50 && height <= 250) {
                  onboardingNotifier.setHeight(height);
                } else if (value.isEmpty) {
                  onboardingNotifier.setHeight(null);
                }
              },
              decoration: InputDecoration(
                hintText: 'Height (cm)',
                helperText: '50 - 250 cm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                final age = int.tryParse(value);

                if (age != null && age > 0 && age <= 150) {
                  onboardingNotifier.setAge(age);
                } else if (value.isEmpty) {
                  onboardingNotifier.setAge(null);
                }
              },
              decoration: InputDecoration(
                hintText: 'Age',
                helperText: '1 - 150 years',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final username = onboardingState.username?.trim() ?? '';
                  if (username.isEmpty ||
                      onboardingState.weight == null ||
                      onboardingState.height == null ||
                      onboardingState.age == null) {
                    AppToast.show(context, 'Please fill in all fields');
                    return;
                  }
                  if (context.mounted) {
                    context.go(AppRoutes.loading);
                  }
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
