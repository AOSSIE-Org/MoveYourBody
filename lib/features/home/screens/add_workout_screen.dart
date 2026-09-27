import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/theme/app_colors.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/features/home/view_model/custom_plans_view_model.dart';
import 'package:move_your_body/features/home/repositories/quick_plan_repository.dart';

class AddWorkoutScreen extends ConsumerWidget {
  const AddWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customPlansAsync = ref.watch(customPlansViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('My Workouts', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Saved Plans',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: customPlansAsync.when(
                data: (plans) {
                  if (plans.isEmpty) {
                    return const Center(
                      child: Text(
                        "You haven't created any custom plans yet.",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      return GestureDetector(
                        onTap: () async {
                           final repo = ref.read(quickPlanRepositoryProvider);
                           final session = await repo.createSessionFromPlan(plan.id);
                           if (session != null && context.mounted) {
                              context.push(AppRoutes.sessionDetailsPath(session.id!));
                           }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.divider, width: 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(30),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.fitness_center, color: AppColors.primary, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  plan.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: \$error')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 72.0),
        child: FloatingActionButton(
          onPressed: () {
            context.push(AppRoutes.createCustomPlan);
          },
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 32),
        ),
      ),
    );
  }
}
