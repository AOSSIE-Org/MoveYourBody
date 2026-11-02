// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../past_session_details_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pastSessionDetails)
final pastSessionDetailsProvider = PastSessionDetailsFamily._();

final class PastSessionDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PastSessionDetailsData>,
          PastSessionDetailsData,
          FutureOr<PastSessionDetailsData>
        >
    with
        $FutureModifier<PastSessionDetailsData>,
        $FutureProvider<PastSessionDetailsData> {
  PastSessionDetailsProvider._({
    required PastSessionDetailsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'pastSessionDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pastSessionDetailsHash();

  @override
  String toString() {
    return r'pastSessionDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PastSessionDetailsData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PastSessionDetailsData> create(Ref ref) {
    final argument = this.argument as int;
    return pastSessionDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PastSessionDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pastSessionDetailsHash() =>
    r'2f2da0443c8666610b0322b4640ebffefbeb2126';

final class PastSessionDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PastSessionDetailsData>, int> {
  PastSessionDetailsFamily._()
    : super(
        retry: null,
        name: r'pastSessionDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PastSessionDetailsProvider call(int sessionId) =>
      PastSessionDetailsProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'pastSessionDetailsProvider';
}
