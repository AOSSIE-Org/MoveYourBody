import 'package:flutter/material.dart';

class NotificationSettingsState {
  final List<TimeOfDay> times;
  final bool isLoading;

  const NotificationSettingsState({
    this.times = const [],
    this.isLoading = true,
  });

  NotificationSettingsState copyWith({
    List<TimeOfDay>? times,
    bool? isLoading,
  }) {
    return NotificationSettingsState(
      times: times ?? this.times,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
