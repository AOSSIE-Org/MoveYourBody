import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/core/widgets/app_scaffold.dart';
import 'package:move_your_body/features/stats/view_model/stats_view_model.dart';
import 'package:move_your_body/features/stats/widgets/session_tile.dart';
import '../../../core/theme/app_colors.dart';

class AllSessionsScreen extends ConsumerWidget {
  const AllSessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(statsViewModelProvider);

    final Map<String, List<Session>> groupedSessions = {};
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final now = DateTime.now();

    for (var session in statsState.allSessions) {
      String dateStr =
          '${session.createdAt.day} ${months[session.createdAt.month - 1]} ${session.createdAt.year}';

      final yesterday = now.subtract(const Duration(days: 1));

      if (session.createdAt.year == now.year &&
          session.createdAt.month == now.month &&
          session.createdAt.day == now.day) {
        dateStr = 'Today';
      } else if (session.createdAt.year == yesterday.year &&
          session.createdAt.month == yesterday.month &&
          session.createdAt.day == yesterday.day) {
        dateStr = 'Yesterday';
      }

      if (!groupedSessions.containsKey(dateStr)) {
        groupedSessions[dateStr] = [];
      }
      groupedSessions[dateStr]!.add(session);
    }

    return AppScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: 8,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                const Expanded(
                  child: Text(
                    "All Sessions",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: statsState.isLoading && statsState.allSessions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    itemCount: groupedSessions.length,
                    itemBuilder: (context, index) {
                      final dateStr = groupedSessions.keys.elementAt(index);
                      final sessions = groupedSessions[dateStr]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16.0,
                              bottom: 12.0,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  dateStr,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...sessions.map((s) => SessionTile(session: s)),
                          const SizedBox(height: 12),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
