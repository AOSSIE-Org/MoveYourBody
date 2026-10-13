import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/theme/app_colors.dart';

class SessionTile extends StatelessWidget {
  final Session session;

  const SessionTile({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final timeStr =
        '${session.createdAt.hour.toString().padLeft(2, '0')}:${session.createdAt.minute.toString().padLeft(2, '0')}';
    final dateStr =
        '${session.createdAt.day} ${months[session.createdAt.month - 1]} ${session.createdAt.year} • $timeStr';

    final statusColor = session.sessionStatus == SessionStatus.completed
        ? AppColors.primary
        : Colors.orangeAccent;

    return GestureDetector(
      onTap: () {
        if (session.id != null) {
          context.push(AppRoutes.pastSessionDetailsPath(session.id!));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                session.sessionStatus == SessionStatus.completed
                    ? Icons.check_circle_rounded
                    : Icons.pending_actions_rounded,
                color: statusColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.isQuickPlan && session.quickPlanName != null
                        ? session.quickPlanName!
                        : 'Workout Session',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (session.sessionDuration != null &&
                    session.sessionDuration! > 0)
                  Text(
                    '${(session.sessionDuration! ~/ 60).toString().padLeft(2, '0')}:${(session.sessionDuration! % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (session.caloriesBurned != null &&
                    session.caloriesBurned! > 0)
                  Text(
                    '${session.caloriesBurned!.toStringAsFixed(1)} kcal',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
