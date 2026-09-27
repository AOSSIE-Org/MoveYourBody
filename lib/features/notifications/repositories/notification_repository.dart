import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

class NotificationRepository {
  static const String _keyNotificationTimes = 'notification_times';

  Future<List<TimeOfDay>> getNotificationTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final timesString = prefs.getStringList(_keyNotificationTimes) ?? [];
    
    return timesString.map((timeStr) {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 9,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
      return const TimeOfDay(hour: 9, minute: 0);
    }).toList();
  }

  Future<void> saveNotificationTimes(List<TimeOfDay> times) async {
    final prefs = await SharedPreferences.getInstance();
    final timesString = times.map((t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}').toList();
    await prefs.setStringList(_keyNotificationTimes, timesString);
  }
}
