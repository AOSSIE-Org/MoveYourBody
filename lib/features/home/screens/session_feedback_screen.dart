import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/theme/app_colors.dart';
import 'package:move_your_body/core/widgets/app_scaffold.dart';
import 'package:move_your_body/core/widgets/feature_chip.dart';
import 'package:move_your_body/features/home/models/session_execution_state.dart';
import 'package:move_your_body/features/home/view_model/session_execution_view_model.dart';

class SessionFeedbackScreen extends ConsumerStatefulWidget {
  final int sessionId;

  const SessionFeedbackScreen({super.key, required this.sessionId});

  @override
  ConsumerState<SessionFeedbackScreen> createState() =>
      _SessionFeedbackScreenState();
}

class _SessionFeedbackScreenState extends ConsumerState<SessionFeedbackScreen> with TickerProviderStateMixin {
  late final AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _formatEnumName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  String _formatDurationToMinSec(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    
    if (minutes == 0) {
      return '$remainingSeconds sec';
    }
    
    return '$minutes min $remainingSeconds sec';
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(
      sessionExecutionViewModelProvider(widget.sessionId),
    );
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return AppScaffold(
      child: Stack(
        children: [
          SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: 70 + bottomInset,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface, 
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),

                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 28,
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.black,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Workout Complete",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "You completed ${sessionState.exercises.length} exercises in ${_formatDurationToMinSec(sessionState.totalElapsedSeconds)}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      "How challenging was this workout for you?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(DifficultyFeedback.values.length, (
                          index,
                        ) {
                          final diffEnum = DifficultyFeedback.values[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index < DifficultyFeedback.values.length - 1 ? 12.0 : 0,
                            ),
                            child: FeatureChip(
                              text: _formatEnumName(diffEnum.name),
                              selected: sessionState.difficultyFeedback == diffEnum,
                              onTap: () {
                                ref.read(sessionExecutionViewModelProvider(widget.sessionId).notifier)
                                   .setDifficultyFeedback(diffEnum);
                              },
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      "How much physical effort did this workout require?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(IntensityFeedback.values.length, (
                          index,
                        ) {
                          final intEnum = IntensityFeedback.values[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index < IntensityFeedback.values.length - 1 ? 12.0 : 0,
                            ),
                            child: FeatureChip(
                              text: _formatEnumName(intEnum.name),
                              selected: sessionState.intensityFeedback == intEnum,
                              onTap: () {
                                ref.read(sessionExecutionViewModelProvider(widget.sessionId).notifier)
                                   .setIntensityFeedback(intEnum);
                              },
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (sessionState.difficultyFeedback != null && sessionState.intensityFeedback != null) {
                            await ref.read(sessionExecutionViewModelProvider(widget.sessionId).notifier).submitFeedback();
                            if (context.mounted) {
                              context.go(AppRoutes.home);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please select both feedbacks before submitting.")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
          ),
        ),
        IgnorePointer(
          child: Lottie.asset(
            'assets/animations/Confetti.json',
            controller: _confettiController,
            onLoaded: (composition) {
              _confettiController
                ..duration = composition.duration * 10
                ..forward();
            },
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            repeat: false,
          ),
        ),
        ],
      ),
    );
  }
}
