// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ai_inference_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiInferenceViewModel)
final aiInferenceViewModelProvider = AiInferenceViewModelProvider._();

final class AiInferenceViewModelProvider
    extends $NotifierProvider<AiInferenceViewModel, AiState> {
  AiInferenceViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiInferenceViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiInferenceViewModelHash();

  @$internal
  @override
  AiInferenceViewModel create() => AiInferenceViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiState>(value),
    );
  }
}

String _$aiInferenceViewModelHash() =>
    r'f69aa121b24971e4bcfd4167dabe37ce85db5d21';

abstract class _$AiInferenceViewModel extends $Notifier<AiState> {
  AiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AiState, AiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiState, AiState>,
              AiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
