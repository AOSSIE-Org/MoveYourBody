import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_flutter/core/widgets/app_toast.dart';
import 'package:template_flutter/core/widgets/onboarding_progress.dart';
import 'package:template_flutter/features/onboarding/view_model/onboarding_view_model.dart';
import '../../../core/widgets/app_scaffold.dart';

class HealthIssuesScreen extends ConsumerWidget {
  const HealthIssuesScreen({super.key});
  static const List<String> healthIssues = [
    'Lower Back Pain',
    'Ankle Pain',
    'Poor Cardiovascular Endurance',
    'Neck Stiffness',
    'Hip Joint',
    'Hamstring Tightness',
    'Knee Pain',
    'Low Flexibility',
    'Tight Muscles',
    'Shortness of Breath During Light Activity',
    'Stress-Related Body Tension',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const OnboardingProgress(currentStep: 1),
            const SizedBox(height: 10),

            Text(
              'Choose Your Health Issues',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 25),

            /// GOAL CHIPS
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 12,
              children: healthIssues.map((issues) {
                final isSelected = onboardingState.healthIssueTags.contains(
                  issues,
                );
                return GestureDetector(
                  onTap: () {
                    onboardingNotifier.toggleHealthIssue(issues);
                  },

                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 50,
                      maxWidth: 250,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.1)
                            : colorScheme.surface.withValues(alpha: 0.7),

                        borderRadius: BorderRadius.circular(18),

                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        issues,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            TextField(
              onChanged: (value) {
                onboardingNotifier.updateCustomHealthIssue(value);
              },
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Any custom health issues',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  if (onboardingState.healthIssueTags.length < 3 &&
                      onboardingState.customHealthIssue.isEmpty) {
                    AppToast.show(
                      context,
                      'Select at least 3 health issues or enter yours',
                    );
                    return;
                  } else {
                    Navigator.of(context).pushNamed('/onboarding/difficulty');
                  }
                },
                child: const Text('Continue'),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
