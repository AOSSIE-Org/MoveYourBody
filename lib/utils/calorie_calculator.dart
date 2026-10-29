import 'package:move_your_body/domain/models/exercise_data.dart';
import 'package:move_your_body/utils/constants/app_constants.dart';

class CalorieCalculator {
  static double _getBaseMetForType(ExerciseType type) {
    switch (type) {
      case ExerciseType.cardio:
        return CalorieConstants.metCardio;
      case ExerciseType.strength:
        return CalorieConstants.metStrength;
      case ExerciseType.dumbbell:
        return CalorieConstants.metDumbbell;
      case ExerciseType.bodyweight:
        return CalorieConstants.metBodyweight;
      case ExerciseType.stabilityBall:
        return CalorieConstants.metStabilityBall;
      case ExerciseType.yoga:
        return CalorieConstants.metYoga;
    }
  }

  static double _getIntensityMultiplier(Intensity intensity) {
    switch (intensity) {
      case Intensity.low:
        return CalorieConstants.intensityMultiplierLow;
      case Intensity.moderate:
        return CalorieConstants.intensityMultiplierModerate;
      case Intensity.high:
        return CalorieConstants.intensityMultiplierHigh;
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
    final durationInHours = durationInSeconds / CalorieConstants.secondsPerHour;

    return finalMet * userWeightKg * durationInHours;
  }
}
