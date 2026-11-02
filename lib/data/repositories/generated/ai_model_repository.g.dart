// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ai_model_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aiModelRepository)
final aiModelRepositoryProvider = AiModelRepositoryProvider._();

final class AiModelRepositoryProvider
    extends
        $FunctionalProvider<
          AiModelRepository,
          AiModelRepository,
          AiModelRepository
        >
    with $Provider<AiModelRepository> {
  AiModelRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiModelRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiModelRepositoryHash();

  @$internal
  @override
  $ProviderElement<AiModelRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AiModelRepository create(Ref ref) {
    return aiModelRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiModelRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiModelRepository>(value),
    );
  }
}

String _$aiModelRepositoryHash() => r'0fd070aad9a775c9576f34db24c5a8cb2a5bf3be';
