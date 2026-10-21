import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:move_your_body/core/theme/app_colors.dart';

class DisclaimerDialog extends StatefulWidget {
  const DisclaimerDialog({super.key});

  static Future<void> showIfNeeded(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool('disclaimer_accepted') ?? false;
    if (!accepted && context.mounted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const DisclaimerDialog(),
      );
    }
  }

  @override
  State<DisclaimerDialog> createState() => _DisclaimerDialogState();
}

class _DisclaimerDialogState extends State<DisclaimerDialog> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 24.0,
      ),
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.primary,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              "Important Precautions",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        context,
                        "AI-Generated Workout Disclaimer",
                        "MoveYourBody generates personalized workout recommendations based on the information you provide. These recommendations may not always be suitable for your individual needs or physical condition. Always listen to your body, and stop an exercise immediately if you experience pain, discomfort, dizziness, or unusual shortness of breath.",
                      ),
                      _buildSection(
                        context,
                        "Voice Control Precaution",
                        "Voice commands may not always be recognized correctly. For safety, avoid relying solely on voice commands while exercising, especially during movements that require balance or concentration. Pause your workout and wait until spoken instructions have finished before giving a voice command.",
                      ),
                      _buildSection(
                        context,
                        "General Fitness Disclaimer",
                        "MoveYourBody is intended for general fitness and educational purposes only. It does not provide medical advice, diagnosis, or treatment. Consult a qualified healthcare professional before starting a new exercise program, particularly if you have an existing injury, medical condition, or concerns about exercising.",
                      ),
                      _buildSection(
                        context,
                        "Exercise Safely",
                        "• Warm up before exercising and use proper form.\n"
                            "• Exercise in a safe environment with enough space.\n"
                            "• Use equipment only as intended and ensure it is stable.\n"
                            "• Stay hydrated and rest when needed.\n"
                            "• Stop exercising if you feel unwell, dizzy, or experience unusual pain.\n"
                            "• Choose exercises that match your current fitness level and physical abilities.",
                      ),
                      _buildSection(
                        context,
                        "Estimated Results",
                        "Workout duration, calorie expenditure, and other fitness estimates are approximate and may not reflect your actual results. They should not be treated as medical measurements.",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isChecked,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    "I acknowledge I have read and understood these precautions.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isChecked
                    ? () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('disclaimer_accepted', true);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: AppColors.surface,
                  disabledForegroundColor: AppColors.textSecondary,
                  side: _isChecked
                      ? BorderSide.none
                      : const BorderSide(color: AppColors.divider),
                ),
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}