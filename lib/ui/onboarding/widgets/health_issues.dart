import 'package:flutter/material.dart';
import 'package:move_your_body/ui/common/onboarding_progress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/routing/app_routes.dart';
import 'package:move_your_body/ui/onboarding/view_models/onboarding_view_model.dart';
import 'package:move_your_body/ui/common/app_scaffold.dart';
import 'package:move_your_body/ui/common/feature_chip.dart';

class HealthIssuesScreen extends ConsumerWidget {
  const HealthIssuesScreen({super.key});
  static const Map<String, String> healthIssuesMap = {
    'Lower Back Pain': 'lower_back_pain',
    'Knee Pain': 'knee_pain',
    'Hip Pain': 'hip_pain',
    'Shoulder Injury': 'shoulder_injury',
    'Wrist Injury': 'wrist_injury',
    'Neck Injury': 'neck_injury',
    'Ankle Injury': 'ankle_injury',
    'Pregnancy': 'pregnancy',
    'Elbow Injury': 'elbow_injury',
    'Rotator Cuff Injury': 'rotator_cuff_injury',
    'Herniated Disc': 'herniated_disc',
    'High Blood Pressure': 'high_blood_pressure',
    'Osteoporosis': 'osteoporosis',
    'Post-Abdominal Surgery': 'post_abdominal_surgery',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedHealthIssues = ref.watch(
      onboardingViewModelProvider.select((state) => state.healthIssueTags),
    );
    final onboardingNotifier = ref.read(onboardingViewModelProvider.notifier);
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
              children: healthIssuesMap.entries.map((entry) {
                final uiText = entry.key;
                final dbTag = entry.value;
                final isSelected = selectedHealthIssues.contains(dbTag);
                return FeatureChip(
                  text: uiText,
                  selected: isSelected,
                  onTap: () {
                    onboardingNotifier.toggleHealthIssue(dbTag);
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
