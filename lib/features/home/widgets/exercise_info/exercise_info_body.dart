import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/theme/app_colors.dart';
import 'package:move_your_body/core/widgets/app_scaffold.dart';
import 'animation_preview.dart';
import 'info_badges.dart';
import 'section_card.dart';

class ExerciseInfoBody extends StatelessWidget {
  final Exercise exercise;

  const ExerciseInfoBody({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return AppScaffold(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 40 + bottomInset,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            const SizedBox(height: 20),
            AnimationPreview(exercise: exercise),
            const SizedBox(height: 24),
            _buildTitleAndTags(),
            const SizedBox(height: 28),
            _buildTextSection('Overview', exercise.overview),
            _buildTextSection('Benefits', exercise.benefits),
            _buildMusclesSection(),
            _buildBodyRegions(),
            _buildGoalTags(),
            _buildInstructionsSection(),
            _buildTextSection('Movement Pattern', exercise.movementPattern),
            _buildEquipmentSection(),
            _buildInjuryRiskSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
        ),
        Expanded(
          child: Text(
            exercise.name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildTitleAndTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ExerciseBadge(
              label: exercise.type.name.toUpperCase(),
              color: AppColors.primary,
            ),
            ExerciseBadge(
              label: exercise.difficulty.name.toUpperCase(),
              color: _difficultyColor(exercise.difficulty),
            ),
            ExerciseBadge(
              label: '${exercise.intensity.name.toUpperCase()} INTENSITY',
              color: _intensityColor(exercise.intensity),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextSection(String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SectionCard(
        title: title,
        child: Text(
          content,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ),
    );
  }

  Widget _buildMusclesSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SectionCard(
        title: 'Muscles Targeted',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (exercise.primaryMuscles.isNotEmpty) ...[
              const Text(
                'Primary',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: exercise.primaryMuscles
                    .map((m) => MuscleChip(label: m, isPrimary: true))
                    .toList(),
              ),
            ],
            if (exercise.secondaryMuscles.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Secondary',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: exercise.secondaryMuscles
                    .map((m) => MuscleChip(label: m, isPrimary: false))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBodyRegions() {
    if (exercise.bodyRegions.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SectionCard(
        title: 'Body Regions',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: exercise.bodyRegions
              .map(
                (r) => ExerciseBadge(
                  label: _formatBodyRegion(r),
                  color: AppColors.primaryLight,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildGoalTags() {
    if (exercise.goalTags.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SectionCard(
        title: 'Goal Tags',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: exercise.goalTags
              .map(
                (g) => ExerciseBadge(
                  label: g.replaceAll('_', ' ').toUpperCase(),
                  color: Colors.tealAccent.shade700,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildInstructionsSection() {
    if (exercise.instructions.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SectionCard(
        title: 'Instructions',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildInstructionSteps(exercise.instructions),
        ),
      ),
    );
  }

  Widget _buildEquipmentSection() {
    if (exercise.equipments.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SectionCard(
        title: 'Equipment Needed',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: exercise.equipments
              .map(
                (e) => ExerciseBadge(
                  label: e.name
                      .replaceAllMapped(
                        RegExp(r'([A-Z])'),
                        (m) => ' ${m.group(0)}',
                      )
                      .trim()
                      .toUpperCase(),
                  color: Colors.orangeAccent.shade700,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildInjuryRiskSection() {
    if (exercise.contraindications.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SectionCard(
        title: 'Injury Risk',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: exercise.contraindications
              .map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "• ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          c
                              .replaceAll('_', ' ')
                              .split(' ')
                              .map((word) {
                                if (word.isEmpty) return '';
                                return word[0].toUpperCase() +
                                    word.substring(1).toLowerCase();
                              })
                              .join(' '),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  List<Widget> _buildInstructionSteps(String instructions) {
    final steps = instructions
        .split('\n')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    return steps.asMap().entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${entry.key + 1}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                entry.value.trim(),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _formatBodyRegion(BodyRegion region) {
    switch (region) {
      case BodyRegion.lowerBody:
        return 'LOWER BODY';
      case BodyRegion.core:
        return 'CORE';
      case BodyRegion.fullBody:
        return 'FULL BODY';
      case BodyRegion.upperBody:
        return 'UPPER BODY';
      case BodyRegion.cardioAndEndurance:
        return 'CARDIO';
      case BodyRegion.mobilityAndFlexibility:
        return 'MOBILITY';
    }
  }

  Color _difficultyColor(Difficulty d) {
    switch (d) {
      case Difficulty.beginner:
        return Colors.greenAccent.shade700;
      case Difficulty.intermediate:
        return Colors.orangeAccent.shade700;
      case Difficulty.advanced:
        return Colors.redAccent.shade700;
    }
  }

  Color _intensityColor(Intensity i) {
    switch (i) {
      case Intensity.low:
        return Colors.lightBlueAccent.shade700;
      case Intensity.moderate:
        return Colors.amberAccent.shade700;
      case Intensity.high:
        return Colors.deepOrangeAccent.shade400;
    }
  }
}
