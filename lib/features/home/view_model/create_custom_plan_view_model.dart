import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/features/home/repositories/quick_plan_repository.dart';


part 'generated/create_custom_plan_view_model.g.dart';

@riverpod
class CreateCustomPlanViewModel extends _$CreateCustomPlanViewModel {
  @override
  List<Exercise> build() {
    return [];
  }

  void toggleExercise(Exercise exercise) {
    if (state.any((e) => e.exerciseId == exercise.exerciseId)) {
      state = state.where((e) => e.exerciseId != exercise.exerciseId).toList();
    } else {
      state = [...state, exercise];
    }
  }
  
  void reorderExercises(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = state.removeAt(oldIndex);
    state.insert(newIndex, item);
    state = [...state];
  }

  Future<int?> saveCustomPlan(String planName) async {
    if (state.isEmpty || planName.trim().isEmpty) return null;
    
    final repo = ref.read(quickPlanRepositoryProvider);
    final exerciseIds = state.map((e) => e.exerciseId).toList();
    
    return await repo.createCustomPlan(planName.trim(), exerciseIds);
  }
}
