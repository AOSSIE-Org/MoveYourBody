class AppConstants {
  AppConstants._();

  static const double bottomNavBarSpacing = 100.0;
  static const int defaultExerciseDurationSeconds = 30;
  static const Duration splashDuration = Duration(milliseconds: 1200);
  static const Duration splashFadeDuration = Duration(milliseconds: 700);
  static const int exercisesDbVersion = 1;
}

class AppAssets {
  AppAssets._();
  static const String appLogo = 'assets/images/move_your_body_logo.png';
  static const String aossieLogo = 'assets/images/aossie_logo.png';
  static const String modelQuantized = 'assets/models/model_quantized.onnx';
  static const String vocabTxt = 'assets/models/vocab.txt';
  static const String exercisesDb = 'assets/exercises.db';
  static const String exercisesDbName = 'exercises.db';
  static const String userDbName = 'move_your_body.db';
}

class AiConstants {
  AiConstants._();
  static const int maxSequenceLength = 128;
}

class CalorieConstants {
  CalorieConstants._();
  static const double secondsPerHour = 3600.0;
  static const double metCardio = 7.0;
  static const double metStrength = 4.0;
  static const double metDumbbell = 4.0;
  static const double metBodyweight = 3.5;
  static const double metStabilityBall = 3.0;
  static const double metYoga = 3.0;
  static const double intensityMultiplierLow = 0.8;
  static const double intensityMultiplierModerate = 1.0;
  static const double intensityMultiplierHigh = 1.2;
}

class AudioConstants {
  AudioConstants._();
  static const int sampleRate = 16000;
  static const int channels = 1;
  static const int bufferSamples = sampleRate * 2;
  static const int processingIntervalMs = 250;
  static const double defaultThreshold = 2.5;
  static const Duration cooldown = Duration(milliseconds: 1200);
  static const double pcmNormalizationFactor = 32768.0;
}

class CacheConstants {
  CacheConstants._();
  static const String exerciseAnimationCacheKey = 'exerciseAnimationCache';
  static const Duration cacheStalePeriod = Duration(days: 3650);
  static const int maxCacheObjects = 1000;
}

class SafetyFilterConstants {
  SafetyFilterConstants._();
  static const int sessionsToSkip = 6;
  static const int minFreshExercisesThreshold = 3;
}

class DbPreferencesKeys {
  DbPreferencesKeys._();
  static const String copiedExercisesDbVersion = 'copied_exercises_db_version';
  static const String disclaimerAccepted = 'disclaimer_accepted';
}
