import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/features/home/repositories/exercise_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/exercise_info_view_model.g.dart';

@riverpod
Future<Exercise?> exerciseInfoViewModel(Ref ref, String exerciseId) async {
  final repo = ref.read(exerciseRepositoryProvider);
  final exercises = await repo.getExercisesByIds([exerciseId]);
  return exercises.isNotEmpty ? exercises.first : null;
}
