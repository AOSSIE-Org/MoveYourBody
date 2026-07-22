import 'package:flutter/material.dart';

class ExerciseNameDisplay extends StatelessWidget {
  final String exerciseName;
  final bool isResting;
  final String? nextExerciseName;

  const ExerciseNameDisplay({
    super.key,
    required this.exerciseName,
    required this.isResting,
    this.nextExerciseName,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      isResting && nextExerciseName != null
          ? "Up Next: $nextExerciseName"
          : exerciseName,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.2,
      ),
    );
  }
}
