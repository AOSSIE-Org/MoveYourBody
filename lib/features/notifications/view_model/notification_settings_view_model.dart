import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/notification_settings_state.dart';
import '../repositories/notification_repository.dart';
import '../services/notification_service.dart';

part 'generated/notification_settings_view_model.g.dart';

@riverpod
class NotificationSettingsViewModel extends _$NotificationSettingsViewModel {
  @override
  NotificationSettingsState build() {
    Future.microtask(() => _initialize());
    return const NotificationSettingsState();
  }

  Future<void> _initialize() async {
    final service = ref.read(notificationServiceProvider);
    await service.init();
    await service.requestPermissions();
    
    final repo = ref.read(notificationRepositoryProvider);
    final times = await repo.getNotificationTimes();
    
    state = state.copyWith(times: times, isLoading: false);
  }

  Future<void> addTime(TimeOfDay time) async {
    if (state.times.any((t) => t.hour == time.hour && t.minute == time.minute)) {
      return;
    }
    
    final newTimes = List<TimeOfDay>.from(state.times)..add(time);
    newTimes.sort((a, b) {
      if (a.hour == b.hour) return a.minute.compareTo(b.minute);
      return a.hour.compareTo(b.hour);
    });
    
    state = state.copyWith(times: newTimes);
    await _saveAndSchedule(newTimes);
  }

  Future<void> removeTime(TimeOfDay time) async {
    final newTimes = state.times.where((t) => !(t.hour == time.hour && t.minute == time.minute)).toList();
    state = state.copyWith(times: newTimes);
    await _saveAndSchedule(newTimes);
  }

  Future<void> _saveAndSchedule(List<TimeOfDay> times) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.saveNotificationTimes(times);
    
    final service = ref.read(notificationServiceProvider);
    await service.scheduleDailyNotifications(times);
  }
}
