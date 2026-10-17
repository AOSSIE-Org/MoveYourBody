import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/features/home/repositories/session_repository.dart';
import 'package:move_your_body/features/home/view_model/session_details_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/session_execution_state.dart';

part 'generated/session_execution_view_model.g.dart';

@riverpod
class SessionExecutionViewModel extends _$SessionExecutionViewModel {
  Timer? _timer;

  @override
  SessionExecutionState build(int sessionId) {
    ref.onDispose(() {
      _timer?.cancel();
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

    _startPhase(ExecutionPhase.preparation);
  }

  void _startPhase(ExecutionPhase phase) {
    _timer?.cancel();

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
        
        final isLastExercise = state.currentExerciseIndex >= state.exercises.length - 1;
        if (isLastExercise) {
          _startPhase(ExecutionPhase.finished);
        } else {
          _startPhase(ExecutionPhase.rest);
        }
        break;
        
      case ExecutionPhase.rest:
        state = state.copyWith(currentExerciseIndex: state.currentExerciseIndex + 1);
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

    final expectedDuration = state.exerciseDurations[currentExercise.exerciseId] ?? 30;
    final performedDuration = expectedDuration - state.remainingSeconds;

    final repo = ref.read(sessionRepositoryProvider);
    await repo.updateSessionExerciseStatus(
      sessionExerciseId: sessionExercise.id!,
      status: ExerciseStatus.completed,
      performedDuration: performedDuration > 0 ? performedDuration : expectedDuration,
    );
  }

  void pauseTimer() {
    state = state.copyWith(isPaused: true);
  }

  void resumeTimer() {
    state = state.copyWith(isPaused: false);
  }

  void skipToNext() {
    _advancePhase();
  }

  void addExtraTime(int seconds) {
    if (state.currentPhase == ExecutionPhase.finished) return;
    state = state.copyWith(remainingSeconds: state.remainingSeconds + seconds);
  }

  Future<void> _finishSession() async {
    _timer?.cancel();
    state = state.copyWith(
      currentPhase: ExecutionPhase.finished,
      remainingSeconds: 0,
      isPaused: true,
    );

    final repo = ref.read(sessionRepositoryProvider);
    await repo.completeSession(
      sessionId: sessionId,
      totalDuration: state.totalElapsedSeconds,
      caloriesBurned: 0.0,
    );
  }
  
  // double _calculateEstimatedCalories() {
  //    we will work in later pr
  // }
}
