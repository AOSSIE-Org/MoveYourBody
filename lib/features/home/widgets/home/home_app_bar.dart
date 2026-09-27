import 'package:flutter/material.dart';
import 'package:move_your_body/features/notifications/widgets/notification_settings_dialog.dart';
import 'package:move_your_body/core/theme/app_colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi Champ 👋",
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                username,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_active_outlined, color: Colors.white, size: 28),
              onPressed: () {
                NotificationSettingsDialog.show(context);
              },
            ),
            const SizedBox(width: 8),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
