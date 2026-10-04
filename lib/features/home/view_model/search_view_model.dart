import 'package:fuzzy/fuzzy.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/features/home/repositories/exercise_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/search_view_model.g.dart';

class SearchState {
  final List<Exercise> allExercises;
  final List<Exercise> filteredExercises;
  final bool isLoading;

  SearchState({
    required this.allExercises,
    required this.filteredExercises,
    required this.isLoading,
  });

  SearchState copyWith({
    List<Exercise>? allExercises,
    List<Exercise>? filteredExercises,
    bool? isLoading,
  }) {
    return SearchState(
      allExercises: allExercises ?? this.allExercises,
      filteredExercises: filteredExercises ?? this.filteredExercises,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class SearchViewModel extends _$SearchViewModel {
  Fuzzy<Exercise>? _fuzzy;

  @override
  SearchState build() {
    Future.microtask(() => _init());
    return SearchState(
      allExercises: [],
      filteredExercises: [],
      isLoading: true,
    );
  }

  Future<void> _init() async {
    final repository = ref.read(exerciseRepositoryProvider);
    final exercises = await repository.getAllExercises();
    exercises.sort((a, b) => a.name.compareTo(b.name));

    _fuzzy = Fuzzy<Exercise>(
      exercises,
      options: FuzzyOptions(
        keys: [
          WeightedKey<Exercise>(
            name: 'name',
            getter: (x) => x.name,
            weight: 1.0,
          ),
          WeightedKey<Exercise>(
            name: 'bodyRegions',
            getter: (x) => x.bodyRegions.map((e) => e.name).join(' '),
            weight: 0.7,
          ),
          WeightedKey<Exercise>(
            name: 'primaryMuscles',
            getter: (x) => x.primaryMuscles.join(' '),
            weight: 0.5,
          ),
          WeightedKey<Exercise>(
            name: 'secondaryMuscles',
            getter: (x) => x.secondaryMuscles.join(' '),
            weight: 0.3,
          ),
          WeightedKey<Exercise>(
            name: 'equipment',
            getter: (x) => x.equipments.map((e) => e.name).join(' '),
            weight: 0.3,
          ),
        ],
        findAllMatches: true,
        tokenize: true,
        threshold: 0.4,
      ),
    );

    state = state.copyWith(
      allExercises: exercises,
      filteredExercises: exercises,
      isLoading: false,
    );
  }

  void search(String query) {
    if (_fuzzy == null) return;

    if (query.trim().isEmpty) {
      state = state.copyWith(filteredExercises: state.allExercises);
      return;
    }

    final results = _fuzzy!.search(query.trim());
    state = state.copyWith(
      filteredExercises: results.map((r) => r.item).toList(),
    );
  }
}
