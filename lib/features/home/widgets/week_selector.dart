import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../view_model/home_view_model.dart';

class WeekSelector extends ConsumerWidget {
  const WeekSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    final days = homeState.currentWeekDays;

    if (days.isEmpty) {
      return const SizedBox.shrink();
    }

    final size = MediaQuery.of(context).size;
    final scale = (size.width / 390).clamp(0.85, 1.25);

    return SizedBox(
      height: 85 * scale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => SizedBox(width: 12 * scale),
        itemBuilder: (_, index) {
          final dayDate = days[index];
          final dayLabel = DateFormat('E').format(dayDate)[0];
          final dateLabel = DateFormat('d').format(dayDate);

          final isSelected =
              dayDate.year == homeState.selectedDate.year &&
              dayDate.month == homeState.selectedDate.month &&
              dayDate.day == homeState.selectedDate.day;

          return Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 46 * scale,
                height: 50 * scale,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white
                      : AppColors.primary.withValues(alpha: .85),
                  borderRadius: BorderRadius.circular(16 * scale),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: .15),
                            blurRadius: 14 * scale,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayLabel,
                      style: TextStyle(
                        color: isSelected ? Colors.black54 : Colors.black45,
                        fontWeight: FontWeight.w600,
                        fontSize: 12 * scale,
                      ),
                    ),
                    SizedBox(height: 4 * scale),
                    Text(
                      dateLabel,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * scale,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6 * scale),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 5 * scale,
                height: 5 * scale,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryLight
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
