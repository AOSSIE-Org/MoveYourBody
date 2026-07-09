// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../onboarding_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OnboardingViewModel)
final onboardingViewModelProvider = OnboardingViewModelProvider._();

final class OnboardingViewModelProvider
    extends $NotifierProvider<OnboardingViewModel, OnboardingData> {
  OnboardingViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingViewModelHash();

  @$internal
  @override
  OnboardingViewModel create() => OnboardingViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingData>(value),
    );
  }
}

String _$onboardingViewModelHash() =>
    r'5fdbbee7dd670dae9a71a037c4f39f4f890ea4e7';

abstract class _$OnboardingViewModel extends $Notifier<OnboardingData> {
  OnboardingData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<OnboardingData, OnboardingData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingData, OnboardingData>,
              OnboardingData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
