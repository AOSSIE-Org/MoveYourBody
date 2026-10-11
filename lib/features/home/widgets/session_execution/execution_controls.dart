import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/theme/app_colors.dart';
import 'package:move_your_body/features/home/view_model/session_execution_view_model.dart';

class ExecutionControls extends ConsumerWidget {
  final int sessionId;

  const ExecutionControls({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaused = ref.watch(
      sessionExecutionViewModelProvider(sessionId)
          .select((state) => state.isPaused),
    );

    final viewModel = ref.read(
      sessionExecutionViewModelProvider(sessionId).notifier,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 60,
          height: 48,
          child: TextButton(
            onPressed: () => viewModel.addExtraTime(10),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.3)),
              ),
            ),
            child: Text(
              "+10s",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        GestureDetector(
          onTap: () {
            if (isPaused) {
              viewModel.resumeTimer();
            } else {
              viewModel.pauseTimer();
            }
          },
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: Icon(
              isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              color: AppColors.primary,
              size: 48,
            ),
          ),
        ),

        IconButton(
          onPressed: () => viewModel.skipToNext(),
          icon: const Icon(Icons.fast_forward),
          color: AppColors.textSecondary,
          iconSize: 32,
        ),
      ],
    );
  }
}
