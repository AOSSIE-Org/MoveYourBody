// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../session_execution_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SessionExecutionViewModel)
final sessionExecutionViewModelProvider = SessionExecutionViewModelFamily._();

final class SessionExecutionViewModelProvider
    extends
        $NotifierProvider<SessionExecutionViewModel, SessionExecutionState> {
  SessionExecutionViewModelProvider._({
    required SessionExecutionViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'sessionExecutionViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionExecutionViewModelHash();

  @override
  String toString() {
    return r'sessionExecutionViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SessionExecutionViewModel create() => SessionExecutionViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionExecutionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionExecutionState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SessionExecutionViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionExecutionViewModelHash() =>
    r'914cc150ac72c4c9c1b5627d38fe44d207deb747';

final class SessionExecutionViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          SessionExecutionViewModel,
          SessionExecutionState,
          SessionExecutionState,
          SessionExecutionState,
          int
        > {
  SessionExecutionViewModelFamily._()
    : super(
        retry: null,
        name: r'sessionExecutionViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SessionExecutionViewModelProvider call(int sessionId) =>
      SessionExecutionViewModelProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'sessionExecutionViewModelProvider';
}

abstract class _$SessionExecutionViewModel
    extends $Notifier<SessionExecutionState> {
  late final _$args = ref.$arg as int;
  int get sessionId => _$args;

  SessionExecutionState build(int sessionId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SessionExecutionState, SessionExecutionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionExecutionState, SessionExecutionState>,
              SessionExecutionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
