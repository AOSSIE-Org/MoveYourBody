import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:move_your_body/core/routing/app_routes.dart';
import 'package:move_your_body/features/home/view_model/quick_plan_view_model.dart';
import 'package:move_your_body/features/home/widgets/home/home_app_bar.dart';
import 'package:move_your_body/features/home/widgets/home/quick_plan_card.dart';
import 'package:move_your_body/features/home/widgets/home/search_bar.dart';
import 'package:move_your_body/features/home/widgets/home/today_session_card.dart';
import 'package:move_your_body/features/home/widgets/home/week_selector.dart';
// import 'package:move_your_body/features/home/widgets/home/weekly_stats_card.dart';
import '../../../core/widgets/app_scaffold.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final quickPlanState = ref.watch(quickPlanViewModelProvider);
    final quickPlanViewModel = ref.read(quickPlanViewModelProvider.notifier);

    ref.listen(quickPlanViewModelProvider, (previous, next) {
      if (next.tapStatus == QuickPlanStatus.error &&
          next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.redAccent,
          ),
        );
        quickPlanViewModel.resetTapStatus();
      }
    });

    return AppScaffold(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 70 + bottomInset,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeAppBar(username: "Vaibhav"),
            const SizedBox(height: 24),
            const HomeSearchBar(),
            const SizedBox(height: 22),
            const WeekSelector(),
            const SizedBox(height: 24),
            const TodaySessionCard(),
            const SizedBox(height: 24),
            Text(
              "Quick plans",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: quickPlanState.isSeeding
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: quickPlanState.plans.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final plan = quickPlanState.plans[index];
                        final isThisPlanLoading =
                            quickPlanState.tapStatus == QuickPlanStatus.loading && quickPlanState.tappedPlanId == plan.id;

                        return QuickPlanCard(
                          title: plan.name,
                          imagePath: plan.imagePath ?? 'assets/images/fat_burn_blast.png',
                          isLoading: isThisPlanLoading,
                          onTap: () async {
                            final session = await quickPlanViewModel
                                .onPlanTapped(plan.id);
                            if (session != null && context.mounted) {
                              context.push(
                                AppRoutes.sessionDetailsPath(session.id!),
                              );
                            }
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),
            // const WeeklyStatsCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
