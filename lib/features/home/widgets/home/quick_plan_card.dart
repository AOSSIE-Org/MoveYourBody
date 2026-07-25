import 'package:flutter/material.dart';
import 'package:move_your_body/core/theme/app_colors.dart';

class QuickPlanCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const QuickPlanCard({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          opacity: 0.75,
          filterQuality: FilterQuality.high,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Positioned(
            bottom: 8,
            left: 8,
            child: Icon(
              Icons.play_circle_fill,
              color: AppColors.primary,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
