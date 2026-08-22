// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../session_details_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SessionDetailsViewModel)
final sessionDetailsViewModelProvider = SessionDetailsViewModelFamily._();

final class SessionDetailsViewModelProvider
    extends $NotifierProvider<SessionDetailsViewModel, SessionDetailsState> {
  SessionDetailsViewModelProvider._({
    required SessionDetailsViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'sessionDetailsViewModelProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionDetailsViewModelHash();

  @override
  String toString() {
    return r'sessionDetailsViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SessionDetailsViewModel create() => SessionDetailsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionDetailsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionDetailsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SessionDetailsViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionDetailsViewModelHash() =>
    r'd91f7de25acae5b6f8ee682199be92c5477f7473';

final class SessionDetailsViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          SessionDetailsViewModel,
          SessionDetailsState,
          SessionDetailsState,
          SessionDetailsState,
          int
        > {
  SessionDetailsViewModelFamily._()
    : super(
        retry: null,
        name: r'sessionDetailsViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  SessionDetailsViewModelProvider call(int sessionId) =>
      SessionDetailsViewModelProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'sessionDetailsViewModelProvider';
}

abstract class _$SessionDetailsViewModel
    extends $Notifier<SessionDetailsState> {
  late final _$args = ref.$arg as int;
  int get sessionId => _$args;

  SessionDetailsState build(int sessionId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SessionDetailsState, SessionDetailsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionDetailsState, SessionDetailsState>,
              SessionDetailsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(animationFile)
final animationFileProvider = AnimationFileFamily._();

final class AnimationFileProvider
    extends $FunctionalProvider<AsyncValue<File>, File, FutureOr<File>>
    with $FutureModifier<File>, $FutureProvider<File> {
  AnimationFileProvider._({
    required AnimationFileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'animationFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$animationFileHash();

  @override
  String toString() {
    return r'animationFileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<File> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<File> create(Ref ref) {
    final argument = this.argument as String;
    return animationFile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AnimationFileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$animationFileHash() => r'b49aaa04a807a634bdb85ade7d6ced8af59f96b3';

final class AnimationFileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<File>, String> {
  AnimationFileFamily._()
    : super(
        retry: null,
        name: r'animationFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AnimationFileProvider call(String url) =>
      AnimationFileProvider._(argument: url, from: this);

  @override
  String toString() => r'animationFileProvider';
}
