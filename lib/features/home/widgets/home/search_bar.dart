import 'package:flutter/material.dart';

import 'package:move_your_body/core/theme/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 390).clamp(0.85, 1.25);

    return TextField(
      style: TextStyle(fontSize: 15 * scale),
      decoration: InputDecoration(
        hintText: "Search exercises or workouts",
        hintStyle: TextStyle(
          fontSize: 15 * scale,
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(Icons.search, size: 22 * scale),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          vertical: 16 * scale,
          horizontal: 16 * scale,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18 * scale),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18 * scale),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }
}
