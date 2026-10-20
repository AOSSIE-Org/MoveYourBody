import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({super.key, required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                7,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == currentStep
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
        ],
      ),
      
    );
  }
}
