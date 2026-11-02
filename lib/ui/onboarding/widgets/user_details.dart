import 'package:flutter/material.dart';
import 'package:move_your_body/ui/core/onboarding_progress.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/routing/app_routes.dart';

import 'package:move_your_body/ui/core/app_scaffold.dart';
import 'package:move_your_body/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:move_your_body/ui/core/app_toast.dart';

class UserdataScreen extends ConsumerWidget {
  const UserdataScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingNotifier = ref.read(onboardingViewModelProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const OnboardingProgress(currentStep: 6),

            const SizedBox(height: 24),

            Text(
              'A few details about you',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              onChanged: (value) =>
                  onboardingNotifier.setUsername(value.trim()),
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
                onboardingNotifier.setWeight(weight ?? 0);
              },
              decoration: InputDecoration(
                hintText: 'Weight (kg)',
                helperText: '10 - 300 kg',
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
                onboardingNotifier.setHeight(height ?? 0);
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
                onboardingNotifier.setAge(age ?? 0);
              },
              decoration: InputDecoration(
                hintText: 'Age',
                helperText: '10 - 100 years',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final state = ref.read(onboardingViewModelProvider);
                  if (state.username == null ||
                      state.username!.trim().isEmpty) {
                    AppToast.show(context, 'Please enter your name');
                    return;
                  }
                  if (state.weight == null ||
                      state.weight! < 10 ||
                      state.weight! > 300) {
                    AppToast.show(
                      context,
                      'Please enter a valid weight (10 - 300 kg)',
                    );
                    return;
                  }
                  if (state.height == null ||
                      state.height! < 50 ||
                      state.height! > 250) {
                    AppToast.show(
                      context,
                      'Please enter a valid height (50 - 250 cm)',
                    );
                    return;
                  }
                  if (state.age == null ||
                      state.age! < 10 ||
                      state.age! > 100) {
                    AppToast.show(
                      context,
                      'Please enter a valid age (10 - 100 years)',
                    );
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
