import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/features/home/repositories/session_repository.dart';
import 'package:move_your_body/features/home/services/calorie_calculator_service.dart';
import 'package:move_your_body/features/home/services/tts_service.dart';
import 'package:move_your_body/features/home/services/voice_command_service.dart';
import 'package:move_your_body/features/home/view_model/session_details_view_model.dart';
import 'package:move_your_body/features/onboarding/repository/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/session_execution_state.dart';

part 'generated/session_execution_view_model.g.dart';

@riverpod
class SessionExecutionViewModel extends _$SessionExecutionViewModel {
  Timer? _timer;
  final TtsService _ttsService = TtsService();
  late final VoiceCommandService _voiceService;

  @override
  SessionExecutionState build(int sessionId) {
    _voiceService = VoiceCommandService(ttsService: _ttsService);

    ref.onDispose(() {
      _timer?.cancel();
      _voiceService.dispose();
      _ttsService.dispose();
    });

    Future.microtask(() => _init());

    final now = DateTime.now();
    return SessionExecutionState(
      session: Session(createdAt: now, sessionStatus: SessionStatus.created),
      exercises: [],
      exerciseDurations: {},
      preparationTime: 10,
      restTime: 15,
    );
  }

  Future<void> _init() async {
    final detailsState = ref.read(sessionDetailsViewModelProvider(sessionId));

    if (detailsState.session == null) {
      debugPrint("Cannot start execution: Session details not found");
      return;
    }

    state = state.copyWith(
      session: detailsState.session!,
      exercises: detailsState.exercises,
      exerciseDurations: detailsState.exerciseDurations,
      preparationTime: detailsState.preparationTime,
      restTime: detailsState.restTime,
      isInitializing: false,
    );

    final sessionRepo = ref.read(sessionRepositoryProvider);
    await sessionRepo.updateSessionStatus(sessionId, SessionStatus.inProgress);
    await _ttsService.init();
    await _voiceService.init();
    _voiceService.onCommandDetected = _handleVoiceCommand;
    _voiceService.startListening();

    _startPhase(ExecutionPhase.preparation);
  }

  void _handleVoiceCommand(VoiceCommand command) {
    debugPrint('Executing voice command: ${command.name}');

    switch (command) {
      case VoiceCommand.resume:
        resumeTimer();
        break;
      case VoiceCommand.pause:
        pauseTimer();
        break;
      case VoiceCommand.skip:
        skipToNext();
        break;
    }
  }

  void _startPhase(ExecutionPhase phase) {
    _timer?.cancel();
    _ttsService.stop();

    int duration = 0;
    switch (phase) {
      case ExecutionPhase.preparation:
        duration = state.preparationTime;
        break;
      case ExecutionPhase.workout:
        final currentExercise = state.exercises[state.currentExerciseIndex];
        duration = state.exerciseDurations[currentExercise.exerciseId] ?? 30;
        break;
      case ExecutionPhase.rest:
        duration = state.restTime;
        break;
      case ExecutionPhase.finished:
        _finishSession();
        return;
    }

    state = state.copyWith(
      currentPhase: phase,
      remainingSeconds: duration,
      isPaused: false,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), _tick);

    if (phase == ExecutionPhase.workout) {
      _speakCurrentExerciseInstructions();
    }
  }
  void _speakCurrentExerciseInstructions() {
    final exercise = state.exercises[state.currentExerciseIndex];
    final segments = exercise.instructions
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (segments.isEmpty) return;
    _ttsService.speakInstructions(segments);
  }

  void _tick(Timer timer) {
    if (state.isPaused) return;

    final newRemaining = state.remainingSeconds - 1;
    final newElapsed = state.totalElapsedSeconds + 1;

    if (newRemaining <= 0) {
      _advancePhase();
      state = state.copyWith(totalElapsedSeconds: newElapsed);
    } else {
      state = state.copyWith(
        remainingSeconds: newRemaining,
        totalElapsedSeconds: newElapsed,
      );
    }
  }

  Future<void> _advancePhase() async {
    _timer?.cancel();

    switch (state.currentPhase) {
      case ExecutionPhase.preparation:
        _startPhase(ExecutionPhase.workout);
        break;

      case ExecutionPhase.workout:
        await _markCurrentExerciseCompleted();

        final isLastExercise =
            state.currentExerciseIndex >= state.exercises.length - 1;
        if (isLastExercise) {
          _startPhase(ExecutionPhase.finished);
        } else {
          _startPhase(ExecutionPhase.rest);
        }
        break;

      case ExecutionPhase.rest:
        state = state.copyWith(
          currentExerciseIndex: state.currentExerciseIndex + 1,
        );
        _startPhase(ExecutionPhase.workout);
        break;

      case ExecutionPhase.finished:
        break;
    }
  }

  Future<void> _markCurrentExerciseCompleted() async {
    final currentExercise = state.exercises[state.currentExerciseIndex];
    final sessionExercise = state.session.exercises.firstWhere(
      (se) => se.exerciseId == currentExercise.exerciseId,
    );

    final expectedDuration =
        state.exerciseDurations[currentExercise.exerciseId] ?? 30;
    final performedDuration = expectedDuration - state.remainingSeconds;

    final repo = ref.read(sessionRepositoryProvider);
    await repo.updateSessionExerciseStatus(
      sessionExerciseId: sessionExercise.id!,
      status: ExerciseStatus.completed,
      performedDuration: performedDuration > 0
          ? performedDuration
          : expectedDuration,
    );
  }

  void pauseTimer() {
    _ttsService.stop();
    state = state.copyWith(isPaused: true);
  }

  void resumeTimer() {
    if (!state.isPaused) return;

    state = state.copyWith(isPaused: false);
    if (state.currentPhase == ExecutionPhase.workout) {
      _speakCurrentExerciseInstructions();
    }
  }

  void skipToNext() {
    _ttsService.stop();
    _advancePhase();
  }

  void addExtraTime(int seconds) {
    if (state.currentPhase == ExecutionPhase.finished) return;
    state = state.copyWith(remainingSeconds: state.remainingSeconds + seconds);
  }

  Future<void> _finishSession() async {
    _timer?.cancel();
    _ttsService.stop();
    _voiceService.stopListening();

    state = state.copyWith(
      currentPhase: ExecutionPhase.finished,
      remainingSeconds: 0,
      isPaused: true,
    );
    
    final caloriesBurned = await _calculateEstimatedCalories();

    final repo = ref.read(sessionRepositoryProvider);
    await repo.completeSession(
      sessionId: sessionId,
      totalDuration: state.totalElapsedSeconds,
      caloriesBurned: caloriesBurned,
    );
  }

  void setDifficultyFeedback(DifficultyFeedback difficulty) {
    state = state.copyWith(difficultyFeedback: difficulty);
  }

  void setIntensityFeedback(IntensityFeedback intensity) {
    state = state.copyWith(intensityFeedback: intensity);
  }

  Future<void> submitFeedback() async {
    final difficulty = state.difficultyFeedback;
    final intensity = state.intensityFeedback;

    if (difficulty == null || intensity == null) {
      debugPrint("Feedback not fully selected");
      return;
    }

    final sessionRepo = ref.read(sessionRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);

    final caloriesBurned = await _calculateEstimatedCalories();

    await sessionRepo.completeSession(
      sessionId: sessionId,
      totalDuration: state.totalElapsedSeconds,
      caloriesBurned: caloriesBurned,
      difficultyFeedback: difficulty.name,
      intensityFeedback: intensity.name,
    );

    final last3Sessions = await sessionRepo.getLastThreeCompletedSessions();

    final currentUserData = await userRepo.getUserData();

    if (last3Sessions.length == 3 && currentUserData != null) {
      final allEasy = last3Sessions.every(
        (s) => s.difficultyFeedback == DifficultyFeedback.easy.name,
      );
      final allHard = last3Sessions.every(
        (s) => s.difficultyFeedback == DifficultyFeedback.hard.name,
      );

      final allLight = last3Sessions.every(
        (s) => s.intensityFeedback == IntensityFeedback.light.name,
      );
      final allHigh = last3Sessions.every(
        (s) => s.intensityFeedback == IntensityFeedback.high.name,
      );

      final currentUserData = await userRepo.getUserData();

      if (currentUserData != null) {
        String newDifficulty = currentUserData.difficulty;
        String newIntensity = currentUserData.intensity;

        if (allEasy) {
          if (newDifficulty == Difficulty.beginner.name) {
            newDifficulty = Difficulty.intermediate.name;
          } else if (newDifficulty == Difficulty.intermediate.name) {
            newDifficulty = Difficulty.advanced.name;
          }
        } else if (allHard) {
          if (newDifficulty == Difficulty.advanced.name) {
            newDifficulty = Difficulty.intermediate.name;
          } else if (newDifficulty == Difficulty.intermediate.name) {
            newDifficulty = Difficulty.beginner.name;
          }
        }
        if (allLight) {
          if (newIntensity == Intensity.low.name) {
            newIntensity = Intensity.moderate.name;
          } else if (newIntensity == Intensity.moderate.name) {
            newIntensity = Intensity.high.name;
          }
        } else if (allHigh) {
          if (newIntensity == Intensity.high.name) {
            newIntensity = Intensity.moderate.name;
          } else if (newIntensity == Intensity.moderate.name) {
            newIntensity = Intensity.low.name;
          }
        }
        if (newDifficulty != currentUserData.difficulty ||
            newIntensity != currentUserData.intensity) {
          await userRepo.updateDifficultyAndIntensity(
            newDifficulty,
            newIntensity,
          );
        }
      }
    }
  }

  Future<double> _calculateEstimatedCalories() async {
    final userRepo = ref.read(userRepositoryProvider);
    final userData = await userRepo.getUserData();
    if (userData == null) return 0.0;

    double totalCalories = 0.0;

    for (var exercise in state.exercises) {
      final duration = state.exerciseDurations[exercise.exerciseId] ?? 30;
      totalCalories += CalorieCalculatorService.calculateCaloriesBurned(
        exercise: exercise,
        userWeightKg: userData.weight,
        durationInSeconds: duration,
      );
    }

    return totalCalories;
  }
}
