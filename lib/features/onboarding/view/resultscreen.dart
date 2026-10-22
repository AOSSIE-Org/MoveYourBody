import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/constants/app_constants.dart';
import 'package:move_your_body/core/theme/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final username = state.username ?? 'User';

    return AppScaffold(
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: AppConstants.bottomNavBarSpacing + bottomInset,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Profile',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  username,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _MetricCard(title: 'Age', value: '${state.age ?? '-'}'),
                  _MetricCard(
                    title: 'Weight',
                    value: '${state.weight ?? '-'} kg',
                  ),
                  _MetricCard(
                    title: 'Height',
                    value: '${state.height ?? '-'} cm',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _SectionTitle(title: 'Fitness Goals'),
              _ChipsWrap(items: state.goalTags.toList()),
              if (state.customGoal.isNotEmpty)
                _InfoTile(
                  icon: Icons.edit_note,
                  title: 'Other Goals:',
                  text: state.customGoal,
                ),
              const SizedBox(height: 24),
              _SectionTitle(title: 'Health Profile'),
              if (state.healthIssueTags.isEmpty &&
                  state.customHealthIssue.isEmpty)
                const _InfoTile(
                  icon: Icons.health_and_safety,
                  title: 'Status:',
                  text: 'No health issues reported',
                )
              else ...[
                if (state.healthIssueTags.isNotEmpty)
                  _ChipsWrap(items: state.healthIssueTags.toList()),
                if (state.customHealthIssue.isNotEmpty)
                  _InfoTile(
                    icon: Icons.medical_information,
                    title: 'Other Issues:',
                    text: state.customHealthIssue,
                  ),
              ],
              const SizedBox(height: 24),
              _SectionTitle(title: 'Workout Preferences'),
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      title: 'Difficulty',
                      value: state.difficulty ?? 'Not set',
                      icon: Icons.fitness_center,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoCard(
                      title: 'Intensity',
                      value: state.intensity ?? 'Not set',
                      icon: Icons.local_fire_department,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionTitle(title: 'Target Body Regions'),
              _ChipsWrap(items: state.targetBodyRegion.toList()),
              const SizedBox(height: 24),
              _SectionTitle(title: 'Available Equipment'),
              _ChipsWrap(items: state.equipments.toList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ChipsWrap extends StatelessWidget {
  const _ChipsWrap({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          'None selected',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          ),
          child: Text(
            item,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.text,
  });
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryLight),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
