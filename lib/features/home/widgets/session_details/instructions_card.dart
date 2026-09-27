import 'package:flutter/material.dart';
import 'package:move_your_body/core/theme/app_colors.dart';

class InstructionsCard extends StatelessWidget {
  const InstructionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Instructions:",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildInstructionPoint(
            "Prepare and take position during prep time before starting the exercise.",
          ),
          const SizedBox(height: 8),
          _buildInstructionPoint(
            "Follow along with the visuals and voice instructions provided.",
          ),
          const SizedBox(height: 20),
          const Text(
            "Voice Controls",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildVoiceControlRow(Icons.pause, "Pause - say to stop"),
          _buildVoiceControlRow(Icons.play_arrow, "Start - say to resume"),
          _buildVoiceControlRow(
            Icons.skip_next,
            "Skip - to skip current exercise",
          ),
          _buildVoiceControlRow(
            Icons.add_circle_outline,
            "Add time - +10 seconds",
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, color: AppColors.primary, size: 8),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceControlRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
