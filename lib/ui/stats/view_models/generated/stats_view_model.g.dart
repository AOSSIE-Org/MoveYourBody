// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../stats_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StatsViewModel)
final statsViewModelProvider = StatsViewModelProvider._();

final class StatsViewModelProvider
    extends $NotifierProvider<StatsViewModel, StatsState> {
  StatsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsViewModelHash();

  @$internal
  @override
  StatsViewModel create() => StatsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatsState>(value),
    );
  }
}

String _$statsViewModelHash() => r'3e478de57ac4f8ba8e5522f86cc93fbaca1e04f6';

abstract class _$StatsViewModel extends $Notifier<StatsState> {
  StatsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StatsState, StatsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StatsState, StatsState>,
              StatsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
