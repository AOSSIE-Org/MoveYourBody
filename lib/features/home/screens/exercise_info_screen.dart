import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/widgets/app_scaffold.dart';
import 'package:move_your_body/features/home/view_model/exercise_info_view_model.dart';
import '../widgets/exercise_info/exercise_info_body.dart';

class ExerciseInfoScreen extends ConsumerWidget {
  final String exerciseId;

  const ExerciseInfoScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncExercise = ref.watch(exerciseInfoViewModelProvider(exerciseId));

    return asyncExercise.when(
      data: (exercise) {
        if (exercise == null) {
          return AppScaffold(
            child: Center(
              child: Text(
                'Exercise not found',
                style: TextStyle(color: Colors.red.shade300, fontSize: 16),
              ),
            ),
          );
        }

        return ExerciseInfoBody(exercise: exercise);
      },
      loading: () => const AppScaffold(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => AppScaffold(
        child: Center(
          child: Text(
            'Error loading exercise',
            style: TextStyle(color: Colors.red.shade300, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

