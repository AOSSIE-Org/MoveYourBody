// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../notification_settings_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationSettingsViewModel)
final notificationSettingsViewModelProvider =
    NotificationSettingsViewModelProvider._();

final class NotificationSettingsViewModelProvider
    extends
        $NotifierProvider<
          NotificationSettingsViewModel,
          NotificationSettingsState
        > {
  NotificationSettingsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSettingsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSettingsViewModelHash();

  @$internal
  @override
  NotificationSettingsViewModel create() => NotificationSettingsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationSettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationSettingsState>(value),
    );
  }
}

String _$notificationSettingsViewModelHash() =>
    r'1588f1f3c4d8d2fdeda270df13f3e9c6a772038b';

abstract class _$NotificationSettingsViewModel
    extends $Notifier<NotificationSettingsState> {
  NotificationSettingsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<NotificationSettingsState, NotificationSettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NotificationSettingsState, NotificationSettingsState>,
              NotificationSettingsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
