import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../view_model/home_view_model.dart';

class TodaySessionCard extends ConsumerWidget {
  const TodaySessionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    final size = MediaQuery.of(context).size;
    final scale = (size.width / 390).clamp(0.85, 1.25);

    if (homeState.isLoading) {
      return SizedBox(
        height: 220 * scale,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (homeState.errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20 * scale),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24 * scale),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          "Error loading recommendations",
          style: TextStyle(color: Colors.red.shade300, fontSize: 15 * scale),
        ),
      );
    }

    final exercises = homeState.recommendedExercises;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20 * scale),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(26 * scale),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 18 * scale,
            offset: Offset(0, 8 * scale),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10 * scale),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(14 * scale),
                ),
                child: Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.primary,
                  size: 22 * scale,
                ),
              ),
              SizedBox(width: 14 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Session",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 22 * scale,
                      ),
                    ),
                    SizedBox(height: 2 * scale),
                    Text(
                      "${exercises.length} Recommended Exercises",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13 * scale,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 22 * scale),
          if (exercises.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20 * scale),
              child: Center(
                child: Text(
                  "No exercises available for today's session.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 15 * scale,
                  ),
                ),
              ),
            )
          else
            Column(
              children: exercises.map((exercise) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 14 * scale),
                  padding: EdgeInsets.all(16 * scale),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .03),
                    borderRadius: BorderRadius.circular(18 * scale),
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: .6),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42 * scale,
                        height: 42 * scale,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: .15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.fitness_center,
                          color: AppColors.primary,
                          size: 20 * scale,
                        ),
                      ),
                      SizedBox(width: 14 * scale),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16 * scale,
                                  ),
                            ),
                            SizedBox(height: 6 * scale),
                            Wrap(
                              spacing: 8 * scale,
                              runSpacing: 8 * scale,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10 * scale,
                                    vertical: 6 * scale,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: .12,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      20 * scale,
                                    ),
                                  ),
                                  child: Text(
                                    exercise.difficulty.name.toUpperCase(),
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11 * scale,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          SizedBox(height: 10 * scale),
          SizedBox(
            width: double.infinity,
            height: 52 * scale,
            child: ElevatedButton.icon(
              onPressed: exercises.isEmpty ? null : () {},
              icon: Icon(Icons.play_arrow_rounded, size: 22 * scale),
              label: Text(
                "Start Session",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16 * scale,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18 * scale),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
