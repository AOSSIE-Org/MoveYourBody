import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/theme/app_colors.dart';
import 'package:move_your_body/core/widgets/app_scaffold.dart';
import 'package:move_your_body/features/home/models/session_execution_state.dart';
import 'package:move_your_body/features/home/view_model/session_execution_view_model.dart';
import 'package:move_your_body/features/home/widgets/session_execution/execution_controls.dart';
import 'package:move_your_body/features/home/widgets/session_execution/execution_top_bar.dart';
import 'package:move_your_body/features/home/widgets/session_execution/phase_indicator.dart';
import 'package:move_your_body/features/home/widgets/session_execution/exercise_name_display.dart';
import 'package:move_your_body/features/home/widgets/session_execution/execution_animation_box.dart';
import 'package:move_your_body/features/home/widgets/session_execution/execution_timer.dart';

class SessionExecutionScreen extends ConsumerWidget {
  final int sessionId;

  const SessionExecutionScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(sessionExecutionViewModelProvider(sessionId), (previous, next) {
      if (next.currentPhase == ExecutionPhase.finished) {
        context.go(AppRoutes.home);
      }
    });

    final state = ref.watch(sessionExecutionViewModelProvider(sessionId));
    final bottomInset = MediaQuery.of(context).padding.bottom;

    if (state.isInitializing) {
      return const AppScaffold(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (state.currentPhase == ExecutionPhase.finished) {
      return AppScaffold(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                "Workout Complete! 🎉",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Finish",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentExercise = state.exercises[state.currentExerciseIndex];
    final isResting = state.currentPhase == ExecutionPhase.rest;

    String? nextExerciseName;
    if (state.currentExerciseIndex + 1 < state.exercises.length) {
      nextExerciseName = state.exercises[state.currentExerciseIndex + 1].name;
    }

    Exercise? nextAnimExercise;
    if (state.currentPhase == ExecutionPhase.preparation) {
      nextAnimExercise = currentExercise;
    } else if (state.currentPhase == ExecutionPhase.rest) {
      if (state.currentExerciseIndex + 1 < state.exercises.length) {
        nextAnimExercise = state.exercises[state.currentExerciseIndex + 1];
      }
    }

    return AppScaffold(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 10.0,
            bottom: 20.0 + bottomInset,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ExecutionTopBar(
                sessionId: sessionId,
                currentIndex: state.currentExerciseIndex,
                totalExercises: state.exercises.length,
              ),

              const SizedBox(height: 16),

              Expanded(
                flex: 4,
                child: ExecutionAnimationBox(
                  exercise: currentExercise,
                  isResting: isResting || state.currentPhase == ExecutionPhase.preparation,
                  nextExercise: nextAnimExercise,
                ),
              ),

              const SizedBox(height: 20),

              PhaseIndicator(phase: state.currentPhase),

              const SizedBox(height: 12),

              ExerciseNameDisplay(
                exerciseName: currentExercise.name,
                isResting: isResting,
                nextExerciseName: nextExerciseName,
              ),

              const SizedBox(height: 16),

              Expanded(
                flex: 2,
                child: Center(
                  child: ExecutionTimer(
                    remainingSeconds: state.remainingSeconds,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ExecutionControls(sessionId: sessionId),
            ],
          ),
        ),
      ),
    );
  }
}
