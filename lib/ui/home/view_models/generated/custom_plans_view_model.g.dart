// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../custom_plans_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomPlansViewModel)
final customPlansViewModelProvider = CustomPlansViewModelProvider._();

final class CustomPlansViewModelProvider
    extends $AsyncNotifierProvider<CustomPlansViewModel, List<QuickPlan>> {
  CustomPlansViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customPlansViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customPlansViewModelHash();

  @$internal
  @override
  CustomPlansViewModel create() => CustomPlansViewModel();
}

String _$customPlansViewModelHash() =>
    r'041d0b2428b0ed00c72bc5bb57a5a463a245f70b';

abstract class _$CustomPlansViewModel extends $AsyncNotifier<List<QuickPlan>> {
  FutureOr<List<QuickPlan>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<QuickPlan>>, List<QuickPlan>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<QuickPlan>>, List<QuickPlan>>,
              AsyncValue<List<QuickPlan>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
