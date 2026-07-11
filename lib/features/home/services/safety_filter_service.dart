import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/core/model/user_data.dart';

final safetyFilterServiceProvider = Provider<SafetyFilterService>((ref) {
  return SafetyFilterService();
});

class SafetyFilterService {
  List<Exercise> filterExercises({
    required List<Exercise> exercises,
    required UserData user,
  }) {
    if (user.healthIssueTags.isEmpty) {
      return exercises;
    }

    return exercises.where((exercise) {
      return !_hasContraindications(
        exercise.contraindications,
        user.healthIssueTags,
      );
    }).toList();
  }

  bool _hasContraindications(
    List<String> contraindications,
    List<String> userHealthIssues,
  ) {
    return contraindications.any((issue) => userHealthIssues.contains(issue));
  }
}
