// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserRepository)
final userRepositoryProvider = UserRepositoryProvider._();

final class UserRepositoryProvider
    extends $AsyncNotifierProvider<UserRepository, UserData?> {
  UserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRepositoryHash();

  @$internal
  @override
  UserRepository create() => UserRepository();
}

String _$userRepositoryHash() => r'0229c0b738565ea84bdbe91d84eece281f6b7b39';

abstract class _$UserRepository extends $AsyncNotifier<UserData?> {
  FutureOr<UserData?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserData?>, UserData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserData?>, UserData?>,
              AsyncValue<UserData?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
