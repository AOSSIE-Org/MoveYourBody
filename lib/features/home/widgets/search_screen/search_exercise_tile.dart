import 'package:flutter/material.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/theme/app_colors.dart';

class SearchExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onInfoTap;

  const SearchExerciseTile({
    super.key,
    required this.exercise,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _MiniBadge(
                      label: exercise.difficulty.name.toUpperCase(),
                      color: _difficultyColor(exercise.difficulty),
                    ),
                    ...exercise.bodyRegions.map(
                      (region) => _MiniBadge(
                        label: _formatBodyRegion(region),
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onInfoTap,
            child: Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
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
}

class _MiniBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
