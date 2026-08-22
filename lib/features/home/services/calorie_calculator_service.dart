import '../../../core/model/exercise_data.dart';

class CalorieCalculatorService {
  static double _getBaseMetForType(ExerciseType type) {
    switch (type) {
      case ExerciseType.cardio:
        return 7.0;
      case ExerciseType.strength:
        return 4.0;
      case ExerciseType.dumbbell:
        return 4.0;
      case ExerciseType.bodyweight:
        return 3.5;
      case ExerciseType.stabilityBall:
        return 3.0;
      case ExerciseType.yoga:
        return 3.0;
    }
  }

  static double _getIntensityMultiplier(Intensity intensity) {
    switch (intensity) {
      case Intensity.low:
        return 0.8;
      case Intensity.moderate:
        return 1.0;
      case Intensity.high:
        return 1.2;
    }
  }

  static double calculateCaloriesBurned({
    required Exercise exercise,
    required double userWeightKg,
    required int durationInSeconds,
  }) {
    if (userWeightKg <= 0 || durationInSeconds <= 0) {
      return 0.0;
    }

    final baseMet = _getBaseMetForType(exercise.type);
    final intensityMultiplier = _getIntensityMultiplier(exercise.intensity);
    
    final finalMet = baseMet * intensityMultiplier;
    final durationInHours = durationInSeconds / 3600.0;
    
    return finalMet * userWeightKg * durationInHours;
  }
}
