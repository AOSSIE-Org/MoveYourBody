import 'package:flutter/material.dart';
import 'package:move_your_body/features/home/widgets/home/home_app_bar.dart';
import 'package:move_your_body/features/home/widgets/home/quick_plan_card.dart';
import 'package:move_your_body/features/home/widgets/home/search_bar.dart';
import 'package:move_your_body/features/home/widgets/home/today_session_card.dart';
import 'package:move_your_body/features/home/widgets/home/week_selector.dart';
import 'package:move_your_body/features/home/widgets/home/weekly_stats_card.dart';
import '../../../core/widgets/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
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
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                separatorBuilder: (_, _) => const SizedBox(width: 16),
                itemBuilder: (_, index) {
                  final plans = [
                    {
                      "title": "Cardio Strength",
                      "image": "assets/images/lower_back.png",
                    },
                    {
                      "title": "Lower back",
                      "image": "assets/images/cardio_strength.png",
                    },
                  ];

                  return QuickPlanCard(
                    title: plans[index]["title"]!,
                    imagePath: plans[index]["image"]!,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const WeeklyStatsCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
