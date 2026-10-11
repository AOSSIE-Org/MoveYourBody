import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/core/theme/app_colors.dart';
import 'package:move_your_body/core/widgets/app_scaffold.dart';
import 'package:move_your_body/features/home/view_model/search_view_model.dart';
import 'package:move_your_body/features/home/view_model/create_custom_plan_view_model.dart';
import 'package:move_your_body/features/home/view_model/custom_plans_view_model.dart';
import 'package:move_your_body/features/home/widgets/search_screen/search_exercise_tile.dart';

class CreateCustomPlanScreen extends ConsumerStatefulWidget {
  const CreateCustomPlanScreen({super.key});

  @override
  ConsumerState<CreateCustomPlanScreen> createState() => _CreateCustomPlanScreenState();
}

class _CreateCustomPlanScreenState extends ConsumerState<CreateCustomPlanScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref.read(searchViewModelProvider.notifier).search(_searchController.text);
  }

  Future<void> _showSaveDialog() async {
    final selectedExercises = ref.read(createCustomPlanViewModelProvider);
    if (selectedExercises.isEmpty) return;

    final TextEditingController nameController = TextEditingController();
    
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Name Your Workout', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: nameController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'e.g. My Sunday Leg Day',
              hintStyle: TextStyle(color: AppColors.textSecondary),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (result == true && nameController.text.trim().isNotEmpty) {
      final id = await ref.read(createCustomPlanViewModelProvider.notifier).saveCustomPlan(nameController.text.trim());
      if (id != null) {
        if (mounted) {
          ref.read(customPlansViewModelProvider.notifier).refreshPlans();
          context.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);
    final selectedExercises = ref.watch(createCustomPlanViewModelProvider);
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 390).clamp(0.85, 1.25);

    return AppScaffold(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(fontSize: 15 * scale, color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search exercises to add",
                          hintStyle: TextStyle(fontSize: 15 * scale, color: AppColors.textSecondary),
                          prefixIcon: Icon(Icons.search, size: 22 * scale, color: Colors.white),
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: EdgeInsets.symmetric(vertical: 16 * scale, horizontal: 16 * scale),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18 * scale),
                            borderSide: const BorderSide(color: AppColors.divider),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18 * scale),
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: searchState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : searchState.filteredExercises.isEmpty
                    ? const Center(
                        child: Text("No exercises found.", style: TextStyle(color: Colors.white)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 20.0),
                        itemCount: searchState.filteredExercises.length,
                        itemBuilder: (context, index) {
                          final exercise = searchState.filteredExercises[index];
                          final isSelected = selectedExercises.any((e) => e.exerciseId == exercise.exerciseId);

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => ref.read(createCustomPlanViewModelProvider.notifier).toggleExercise(exercise),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12.0, bottom: 16.0),
                                  child: Icon(
                                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                    size: 28,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => ref.read(createCustomPlanViewModelProvider.notifier).toggleExercise(exercise),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: SearchExerciseTile(
                                      exercise: exercise,
                                      onInfoTap: () {
                                        context.push(AppRoutes.exerciseInfoPath(exercise.exerciseId));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              if (selectedExercises.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border(top: BorderSide(color: AppColors.divider)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _showSaveDialog,
                      label: Text('Save Plan (${selectedExercises.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      icon: const Icon(Icons.save),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
