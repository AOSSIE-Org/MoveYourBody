// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../create_custom_plan_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateCustomPlanViewModel)
final createCustomPlanViewModelProvider = CreateCustomPlanViewModelProvider._();

final class CreateCustomPlanViewModelProvider
    extends $NotifierProvider<CreateCustomPlanViewModel, List<Exercise>> {
  CreateCustomPlanViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createCustomPlanViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createCustomPlanViewModelHash();

  @$internal
  @override
  CreateCustomPlanViewModel create() => CreateCustomPlanViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Exercise> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Exercise>>(value),
    );
  }
}

String _$createCustomPlanViewModelHash() =>
    r'b7d38389c50c346802d96d17e7691e2f612caa96';

abstract class _$CreateCustomPlanViewModel extends $Notifier<List<Exercise>> {
  List<Exercise> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Exercise>, List<Exercise>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Exercise>, List<Exercise>>,
              List<Exercise>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
