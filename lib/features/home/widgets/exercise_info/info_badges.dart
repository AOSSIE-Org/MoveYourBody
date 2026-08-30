import 'package:flutter/material.dart';
import 'package:move_your_body/core/theme/app_colors.dart';

class ExerciseBadge extends StatelessWidget {
  final String label;
  final Color color;

  const ExerciseBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

class MuscleChip extends StatelessWidget {
  final String label;
  final bool isPrimary;

  const MuscleChip({super.key, required this.label, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    final color = isPrimary ? AppColors.primary : Colors.white60;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label.replaceAll('_', ' '),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
