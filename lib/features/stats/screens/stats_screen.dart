import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/widgets/app_scaffold.dart';
import 'package:move_your_body/core/theme/app_colors.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/features/stats/widgets/activity_calendar.dart';
import 'package:move_your_body/features/stats/widgets/weekly_time_chart.dart';
import 'package:move_your_body/features/stats/widgets/session_tile.dart';
import 'package:move_your_body/features/stats/view_model/stats_view_model.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(statsViewModelProvider);

    return AppScaffold(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activity Review',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 24),

            statsState.isLoading && statsState.activeDates.isEmpty
                ? const _SkeletonCalendar()
                : ActivityCalendar(activeDates: statsState.activeDates),

            if (!statsState.isLoading)
              WeeklyTimeChart(allSessions: statsState.allSessions),

            const SizedBox(height: 32),

            const Text(
              'Recent Sessions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            if (statsState.isLoading && statsState.allSessions.isEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) => const _SkeletonSessionTile(),
              )
            else if (statsState.allSessions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'No sessions completed yet. Time to move your body!',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: statsState.allSessions.length > 3
                        ? 3
                        : statsState.allSessions.length,
                    itemBuilder: (context, index) {
                      final session = statsState.allSessions[index];
                      return SessionTile(session: session);
                    },
                  ),
                  if (statsState.allSessions.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton.icon(
                        onPressed: () {
                          context.push(AppRoutes.allSessions);
                        },
                        icon: const Icon(
                          Icons.list_alt,
                          color: AppColors.primary,
                        ),
                        label: const Text(
                          'View All Sessions',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _SkeletonCalendar extends StatelessWidget {
  const _SkeletonCalendar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _SkeletonSessionTile extends StatelessWidget {
  const _SkeletonSessionTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 76,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
