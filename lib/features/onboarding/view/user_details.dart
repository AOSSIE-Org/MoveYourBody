import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_flutter/core/widgets/app_toast.dart';
import 'package:template_flutter/core/widgets/onboarding_progress.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class UserdataScreen extends ConsumerWidget {
  const UserdataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final onboardingState = ref.watch(onboardingProvider);
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
              onChanged: (value) {
                onboardingNotifier.setWeight(double.tryParse(value));
              },
              decoration: InputDecoration(
                hintText: 'Weight (kg)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                onboardingNotifier.setHeight(double.tryParse(value));
              },
              decoration: InputDecoration(
                hintText: 'Height (cm)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                onboardingNotifier.setAge(int.tryParse(value));
              },
              decoration: InputDecoration(
                hintText: 'Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (onboardingState.username?.trim().isEmpty != false ||
                      onboardingState.weight == null ||
                      onboardingState.height == null ||
                      onboardingState.age == null) {
                    AppToast.show(context, 'Please fill in all fields');
                    return;
                  } else {
                    Navigator.pushNamed(context, '/onboarding/result');
                  }
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
