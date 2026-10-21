import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const CustomBottomNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.4),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.30),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildNavItem(0, Icons.home_rounded, "Home"),
              _buildNavItem(1, Icons.add_circle_outline_rounded, "Add"),
              _buildNavItem(2, Icons.bar_chart_rounded, "Stats"),
              _buildNavItem(3, Icons.person_outline_rounded, "Profile"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = navigationShell.currentIndex == index;

    return Expanded(
      flex: isSelected ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => navigationShell.goBranch(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.fastOutSlowIn,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.border : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
