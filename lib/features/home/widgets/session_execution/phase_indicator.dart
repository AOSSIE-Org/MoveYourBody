import 'package:flutter/material.dart';
import 'package:move_your_body/core/theme/app_colors.dart';
import 'package:move_your_body/features/home/models/session_execution_state.dart';

class PhaseIndicator extends StatelessWidget {
  final ExecutionPhase phase;

  const PhaseIndicator({super.key, required this.phase});

  @override
  Widget build(BuildContext context) {
    final isResting = phase == ExecutionPhase.rest;
    final isPrep = phase == ExecutionPhase.preparation;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isResting ? Colors.blue.withValues(alpha: 0.2) : 
               isPrep ? Colors.orange.withValues(alpha: 0.2) : 
               AppColors.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isResting ? Colors.blue : 
                 isPrep ? Colors.orange : 
                 AppColors.primary,
        ),
      ),
      child: Text(
        _getPhaseText(phase).toUpperCase(),
        style: TextStyle(
          color: isResting ? Colors.blue : 
                 isPrep ? Colors.orange : 
                 AppColors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  String _getPhaseText(ExecutionPhase phase) {
    switch (phase) {
      case ExecutionPhase.preparation: return "Get Ready";
      case ExecutionPhase.workout: return "Workout";
      case ExecutionPhase.rest: return "Rest";
      case ExecutionPhase.finished: return "Finished";
    }
  }
}
