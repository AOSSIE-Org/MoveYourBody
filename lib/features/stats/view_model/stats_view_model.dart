import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/features/home/repositories/session_repository.dart';

part 'generated/stats_view_model.g.dart';

class StatsState {
  final List<DateTime> activeDates;
  final List<Session> allSessions;
  final bool isLoading;

  StatsState({
    required this.activeDates,
    required this.allSessions,
    required this.isLoading,
  });
}

@riverpod
class StatsViewModel extends _$StatsViewModel {
  @override
  StatsState build() {
    Future.microtask(() => _fetchData());
    return StatsState(activeDates: [], allSessions: [], isLoading: true);
  }

  Future<void> _fetchData() async {
    try {
      final repository = ref.read(sessionRepositoryProvider);

      final sessions = await repository.getAllSessions();

      final completedSessions = sessions
          .where((s) => s.sessionStatus == SessionStatus.completed)
          .toList();
      final List<DateTime> dates = completedSessions
          .map((s) => s.createdAt)
          .toList();

      sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = StatsState(
        activeDates: dates,
        allSessions: sessions,
        isLoading: false,
      );
    } catch (e) {
      state = StatsState(activeDates: [], allSessions: [], isLoading: false);
    }
  }
}
