import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/theme/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 390).clamp(0.85, 1.25);

    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.search);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 16 * scale,
          horizontal: 16 * scale,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18 * scale),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 22 * scale,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 12 * scale),
            Text(
              "Search exercises or workouts",
              style: TextStyle(
                fontSize: 15 * scale,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
