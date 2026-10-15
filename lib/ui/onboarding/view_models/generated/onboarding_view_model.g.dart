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
    extends $NotifierProvider<OnboardingViewModel, UserData> {
  OnboardingViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingViewModelHash();

  @$internal
  @override
  OnboardingViewModel create() => OnboardingViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserData>(value),
    );
  }
}

String _$onboardingViewModelHash() =>
    r'de04016863fcda5ef89620d05cc02ed6cd2b46c1';

abstract class _$OnboardingViewModel extends $Notifier<UserData> {
  UserData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UserData, UserData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserData, UserData>,
              UserData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
