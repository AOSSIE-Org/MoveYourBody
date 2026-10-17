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
         isAutoDispose: true,
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
    r'2e92604d1f01987dc7283babca5cf65cd3e25bbe';

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
        isAutoDispose: true,
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
