import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/widgets/app_scaffold.dart';
import '../../../core/widgets/feature_chip.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// LOGO + TITLE
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Center(
                          child: IntrinsicWidth(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 95,
                                  height: 95,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorScheme.surface,
                                    border: Border.all(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.35,
                                      ),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 24,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 18),

                                Container(
                                  width: 1,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.45,
                                    ),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),

                                const SizedBox(width: 18),

                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(text: 'Your '),
                                        TextSpan(
                                          text: 'AI',
                                          style: textTheme.headlineLarge
                                              ?.copyWith(
                                                color: colorScheme.primary,
                                              ),
                                        ),
                                        const TextSpan(text: ' Fitness Mentor'),
                                      ],
                                    ),
                                    style: textTheme.headlineLarge?.copyWith(
                                      height: 1.05,
                                      letterSpacing: -1,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// FEATURES
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: const [
                          FeatureChip(
                            text:
                                'Smart short workouts tailored personalised to your goals',
                          ),
                          FeatureChip(
                            text:
                                'Designed for busy schedules and daily consistency',
                          ),
                          FeatureChip(
                            text: 'Fully offline and privacy-focused',
                          ),
                          FeatureChip(
                            text: 'Make movement enjoyable, not a burden',
                          ),
                        ],
                      ),

                      /// BUTTON + SUBTEXT
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context.push(AppRoutes.goals);
                              },
                              child: const Text('Get Started'),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            'A few quick questions to personalize your experience.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.75,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
