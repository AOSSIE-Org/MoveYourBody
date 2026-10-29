// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../exercise_info_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(exerciseInfoViewModel)
final exerciseInfoViewModelProvider = ExerciseInfoViewModelFamily._();

final class ExerciseInfoViewModelProvider
    extends
        $FunctionalProvider<
          AsyncValue<Exercise?>,
          Exercise?,
          FutureOr<Exercise?>
        >
    with $FutureModifier<Exercise?>, $FutureProvider<Exercise?> {
  ExerciseInfoViewModelProvider._({
    required ExerciseInfoViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'exerciseInfoViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exerciseInfoViewModelHash();

  @override
  String toString() {
    return r'exerciseInfoViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Exercise?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Exercise?> create(Ref ref) {
    final argument = this.argument as String;
    return exerciseInfoViewModel(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseInfoViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exerciseInfoViewModelHash() =>
    r'5a26de5d17e11c12664da6ec73783c4ad631d907';

final class ExerciseInfoViewModelFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Exercise?>, String> {
  ExerciseInfoViewModelFamily._()
    : super(
        retry: null,
        name: r'exerciseInfoViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExerciseInfoViewModelProvider call(String exerciseId) =>
      ExerciseInfoViewModelProvider._(argument: exerciseId, from: this);

  @override
  String toString() => r'exerciseInfoViewModelProvider';
}
