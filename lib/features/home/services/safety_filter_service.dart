import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/user_data.dart';

final safetyFilterServiceProvider = Provider<SafetyFilterService>((ref) {
  return SafetyFilterService();
});

class SafetyFilterService {
  static const int sessionsToSkip = 6;
  List<Exercise> filterExercises({
    required List<Exercise> exercises,
    required UserData user,
    required List<String> recentExerciseIds,
  }) {
    // 1. Health & Safety Filter
    List<Exercise> safeExercises = exercises;
    
    if (user.healthIssueTags.isNotEmpty) {
      safeExercises = exercises.where((exercise) {
        return !_hasContraindications(
          exercise.contraindications,
          user.healthIssueTags,
        );
      }).toList();
    }

    // 2. Anti-Boredom Filter
    if (recentExerciseIds.isEmpty) {
      return safeExercises;
    }

    final freshExercises = safeExercises.where((ex) => !recentExerciseIds.contains(ex.exerciseId)).toList();
    if (freshExercises.length < 3) {
      return safeExercises;
    }

    return freshExercises;
  }

  bool _hasContraindications(
    List<String> contraindications,
    List<String> userHealthIssues,
  ) {
    return contraindications.any((issue) => userHealthIssues.contains(issue));
  }
}
