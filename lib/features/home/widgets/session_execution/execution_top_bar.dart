import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/theme/app_colors.dart';
import 'package:move_your_body/features/home/view_model/session_execution_view_model.dart';

class ExecutionTopBar extends ConsumerWidget {
  final int sessionId;
  final int currentIndex;
  final int totalExercises;

  const ExecutionTopBar({
    super.key,
    required this.sessionId,
    required this.currentIndex,
    required this.totalExercises,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => _showExitConfirmation(context, ref),
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
        ),
        Text(
          "Exercise ${currentIndex + 1} of $totalExercises",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  void _showExitConfirmation(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(sessionExecutionViewModelProvider(sessionId).notifier);
    viewModel.pauseTimer();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('End Workout?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to end this session early? Your progress so far is saved.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              viewModel.resumeTimer();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('End Session', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
