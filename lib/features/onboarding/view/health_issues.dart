import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/features/onboarding/view_model/onboarding_view_model.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/feature_chip.dart';

class HealthIssuesScreen extends ConsumerWidget {
  const HealthIssuesScreen({super.key});
  static const List<String> healthIssues = [
    'Lower Back Pain',
    'Knee Pain',
    'Hip Pain',
    'Shoulder Injury',
    'Wrist Injury',
    'Neck Injury',
    'Ankle Injury',
    'Pregnancy',
    'Elbow Injury',
    'Rotator Cuff Injury',
    'Herniated Disc',
    'Osteoporosis',
    'High Blood Pressure',
    'Post-Abdominal Surgery',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHealthIssues = ref.watch(
      onboardingViewModelProvider.select((state) => state.healthIssueTags),
    );
    final onboardingNotifier = ref.read(onboardingViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  tooltip: 'Go back',
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      6,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == 0 ? 8 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == 0
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
                final isSelected = selectedHealthIssues.contains(issues);
                return FeatureChip(
                  text: issues,
                  selected: isSelected,
                  onTap: () {
                    onboardingNotifier.toggleHealthIssue(issues);
                  },
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
                  context.push(AppRoutes.difficulty);
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
