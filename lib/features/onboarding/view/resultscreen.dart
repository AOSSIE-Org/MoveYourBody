// this file to just that what we are collection for onboarding and then we will use this data to show the result in the result screen
// after mentor review this will be removed

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/ai_inference/repositories/tag_setup_repository.dart';
import 'package:move_your_body/features/home/services/recommendation_service.dart';
import 'package:move_your_body/features/onboarding/repository/user_repository.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  List<Exercise>? _recommendedExercises;
  bool _isLoading = false;

  Widget _buildBadge(
    BuildContext context,
    String label,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Collected Onboarding Data',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),

            _DataTile(
              title: 'Username',
              value: state.username?.toString() ?? '',
            ),

            _DataTile(title: 'Age', value: state.age?.toString() ?? ''),

            _DataTile(title: 'Height', value: '${state.height ?? ''} cm'),

            _DataTile(title: 'Weight', value: '${state.weight ?? ''} kg'),

            _DataTile(title: 'Goals', value: state.goalTags.join(', ')),

            _DataTile(title: 'Custom Goal', value: state.customGoal),

            _DataTile(
              title: 'Health Issues',
              value: state.healthIssueTags.join(', '),
            ),

            _DataTile(
              title: 'Custom Health Issue',
              value: state.customHealthIssue,
            ),

            _DataTile(title: 'Difficulty', value: state.difficulty ?? ''),

            _DataTile(title: 'Intensity', value: state.intensity ?? ''),

            _DataTile(
              title: 'Target Body Region',
              value: state.targetBodyRegion.join(', '),
            ),

            _DataTile(title: 'Equipments', value: state.equipments.join(', ')),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.surface.withValues(alpha: 0.75),
                      foregroundColor: colorScheme.onSurface,
                      side: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    onPressed: () async {
                      await ref
                          .read(tagSetupRepositoryProvider)
                          .debugPrintAllCachedTags();
                      await UserRepository().debugPrintUserData();
                    },
                    child: const Text('Get DB Tags'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final user = await ref
                            .read(userRepositoryProvider)
                            .getUserData();

                        if (!context.mounted) return;

                        if (user == null) {
                          debugPrint("No user found");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No user found in the database. Please complete onboarding first.'),
                            ),
                          );
                          return;
                        }

                        final exercises = await ref
                            .read(recommendationServiceProvider)
                            .recommendExercises(user);

                        debugPrint("===== Recommended Exercises =====");

                        for (final exercise in exercises) {
                          debugPrint(exercise.name);
                        }

                        if (!context.mounted) return;

                        setState(() {
                          _recommendedExercises = exercises;
                        });
                      } catch (e, stack) {
                        debugPrint("Recommendation error: $e\n$stack");
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    child: const Text("Run Recommendation"),
                  ),
                ),
              ],
            ),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_recommendedExercises != null) ...[
              const SizedBox(height: 32),
              Text(
                'Top Recommended Exercises',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              if (_recommendedExercises!.isEmpty)
                Text(
                  'No exercises matched your preferences.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                )
              else
                ..._recommendedExercises!.map((exercise) => Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      color: colorScheme.surface.withValues(alpha: 0.75),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name,
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildBadge(
                                  context,
                                  'Difficulty: ${exercise.difficulty.name}',
                                  colorScheme.primary.withValues(alpha: 0.15),
                                  colorScheme.primary,
                                ),
                                _buildBadge(
                                  context,
                                  'Intensity: ${exercise.intensity.name}',
                                  Colors.orangeAccent.withValues(alpha: 0.15),
                                  Colors.orangeAccent,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Focus: ${exercise.bodyRegions.map((e) => e.name).join(", ")}',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (exercise.overview.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                exercise.overview,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _DataTile extends StatelessWidget {
  const _DataTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 6),

            Text(value.isEmpty ? 'Not Provided' : value),
          ],
        ),
      ),
    );
  }
}
