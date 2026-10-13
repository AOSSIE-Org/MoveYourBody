// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../quick_plan_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuickPlanViewModel)
final quickPlanViewModelProvider = QuickPlanViewModelProvider._();

final class QuickPlanViewModelProvider
    extends $NotifierProvider<QuickPlanViewModel, QuickPlanState> {
  QuickPlanViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickPlanViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quickPlanViewModelHash();

  @$internal
  @override
  QuickPlanViewModel create() => QuickPlanViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuickPlanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuickPlanState>(value),
    );
  }
}

String _$quickPlanViewModelHash() =>
    r'15494e98a40aef166151a7c0487c7472a3dfe8ee';

abstract class _$QuickPlanViewModel extends $Notifier<QuickPlanState> {
  QuickPlanState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<QuickPlanState, QuickPlanState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QuickPlanState, QuickPlanState>,
              QuickPlanState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
