import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/widgets/app_scaffold.dart';
import 'package:move_your_body/features/home/repositories/exercise_repository.dart';
import '../widgets/exercise_info/exercise_info_body.dart';

class ExerciseInfoScreen extends ConsumerWidget {
  final String exerciseId;

  const ExerciseInfoScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Exercise?>(
      future: _loadExercise(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppScaffold(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final exercise = snapshot.data;
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
    );
  }

  Future<Exercise?> _loadExercise(WidgetRef ref) async {
    final repo = ref.read(exerciseRepositoryProvider);
    final exercises = await repo.getExercisesByIds([exerciseId]);
    return exercises.isNotEmpty ? exercises.first : null;
  }
}

