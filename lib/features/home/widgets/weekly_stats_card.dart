import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WeeklyStatsCard extends StatelessWidget {
  const WeeklyStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStat("3 / 5", "sessions", Icons.check_circle_outline),
          _buildStat("100", "calories", Icons.local_fire_department),
          _buildStat("2", "Day Streak", Icons.bolt),
        ],
      ),
    );
  }

  Widget _buildStat(String val, String label, IconData icon) => Column(
    children: [
      Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      Text(
        label,
        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
      ),
    ],
  );
}
