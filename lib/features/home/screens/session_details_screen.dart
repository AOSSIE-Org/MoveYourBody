import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../view_model/session_details_view_model.dart';
import '../widgets/session_details/exercise_tile.dart';
import '../widgets/session_details/instructions_card.dart';
import '../widgets/session_details/timing_settings_card.dart';

class SessionDetailsScreen extends ConsumerWidget {
  final int sessionId;

  const SessionDetailsScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionDetailsViewModelProvider(sessionId));
    final viewModel = ref.read(
      sessionDetailsViewModelProvider(sessionId).notifier,
    );
    final bottomInset = MediaQuery.of(context).padding.bottom;

    if (state.isLoading) {
      return const AppScaffold(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.errorMessage != null) {
      return AppScaffold(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              state.errorMessage!,
              style: TextStyle(color: Colors.red.shade300, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final exercises = state.exercises;

    return AppScaffold(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 70 + bottomInset,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                const Expanded(
                  child: Text(
                    "Session Details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              "Personalized workout Training",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Set your preferred duration for each exercise",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              "Exercises",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...exercises.map(
              (exercise) => ExerciseTile(
                title: exercise.name,
                durationSeconds:
                    state.exerciseDurations[exercise.exerciseId] ?? 30,
                onDurationChanged: (seconds) {
                  viewModel.updateExerciseDuration(
                    exercise.exerciseId,
                    seconds,
                  );
                },
                onInfoTap: () {
                  context.push(
                    AppRoutes.exerciseInfoPath(exercise.exerciseId),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            TimingSettingsCard(
              preparationTime: state.preparationTime,
              restTime: state.restTime,
              onPreparationTimeChanged: viewModel.updatePreparationTime,
              onRestTimeChanged: viewModel.updateRestTime,
            ),

            const SizedBox(height: 24),

            const InstructionsCard(),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_fill, size: 28),
                  SizedBox(width: 8),
                  Text(
                    "Let's start",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
