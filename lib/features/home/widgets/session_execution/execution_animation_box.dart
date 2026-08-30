import 'package:flutter/material.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/theme/app_colors.dart';
import 'package:move_your_body/features/home/widgets/exercise_info/animation_preview.dart';

class ExecutionAnimationBox extends StatelessWidget {
  final Exercise exercise;
  final bool isResting;
  final Exercise? nextExercise;

  const ExecutionAnimationBox({
    super.key,
    required this.exercise,
    required this.isResting,
    this.nextExercise,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: isResting
          ? (nextExercise != null
              ? AnimationPreview(exercise: nextExercise!, height: null)
              : const Center(
                  child: Icon(
                    Icons.coffee,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                ))
          : AnimationPreview(exercise: exercise, height: null),
    );
  }
}
