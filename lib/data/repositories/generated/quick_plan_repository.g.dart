// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../quick_plan_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(quickPlanRepository)
final quickPlanRepositoryProvider = QuickPlanRepositoryProvider._();

final class QuickPlanRepositoryProvider
    extends
        $FunctionalProvider<
          QuickPlanRepository,
          QuickPlanRepository,
          QuickPlanRepository
        >
    with $Provider<QuickPlanRepository> {
  QuickPlanRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickPlanRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quickPlanRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuickPlanRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  QuickPlanRepository create(Ref ref) {
    return quickPlanRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuickPlanRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuickPlanRepository>(value),
    );
  }
}

String _$quickPlanRepositoryHash() =>
    r'4579feb1912a00c4fef634c3110158a818e4436e';
