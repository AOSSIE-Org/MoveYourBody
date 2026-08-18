import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/core/theme/app_colors.dart';

class WeeklyTimeChart extends StatelessWidget {
  final List<Session> allSessions;

  const WeeklyTimeChart({super.key, required this.allSessions});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final dailyDurations = List<int>.filled(7, 0);

    for (var session in allSessions) {
      if (session.sessionStatus != SessionStatus.completed) continue;

      final date = session.createdAt;
      final sessionDate = DateTime(date.year, date.month, date.day);

      final difference = sessionDate.difference(startOfWeek).inDays;
      if (difference >= 0 && difference < 7) {
        dailyDurations[difference] += (session.sessionDuration ?? 0);
      }
    }

    final maxDuration = dailyDurations.reduce((a, b) => a > b ? a : b);
    final double maxY = maxDuration > 60 ? maxDuration.toDouble() * 1.3 : 60.0;

    double yInterval = 3600;
    if (maxY <= 600) {
      yInterval = 60;
    } else if (maxY <= 3600) {
      yInterval = 600;
    } else {
      yInterval = 3600;
    }

    String formatDuration(int seconds) {
      if (seconds == 0) return '';
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      if (remainingSeconds == 0) {
        return '$minutes';
      } else {
        return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        RichText(
          text: const TextSpan(
            text: 'Time spent this week ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: '(in minutes)',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        AspectRatio(
          aspectRatio: 1.5,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = (constraints.maxWidth * 0.06).clamp(12.0, 32.0);

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    enabled: false,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.transparent,
                      tooltipPadding: const EdgeInsets.only(bottom: 4),
                      tooltipMargin: 0,
                      fitInsideHorizontally: false,
                      fitInsideVertically: false,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final duration = dailyDurations[groupIndex];
                        if (duration == 0) return null;
                        return BarTooltipItem(
                          formatDuration(duration),
                          TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          );
                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = 'Mon';
                              break;
                            case 1:
                              text = 'Tue';
                              break;
                            case 2:
                              text = 'Wed';
                              break;
                            case 3:
                              text = 'Thu';
                              break;
                            case 4:
                              text = 'Fri';
                              break;
                            case 5:
                              text = 'Sat';
                              break;
                            case 6:
                              text = 'Sun';
                              break;
                            default:
                              text = '';
                              break;
                          }
                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Text(text, style: style),
                          );
                        },
                        reservedSize: 32,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value == 0 || value % yInterval != 0)
                            return const SizedBox.shrink();

                          String text = '';
                          if (maxY <= 3600) {
                            final mins = value ~/ 60;
                            if (mins > 0) text = '${mins}m';
                          } else {
                            final hours = value ~/ 3600;
                            if (hours > 0 && value % 3600 == 0) {
                              text = '${hours}h';
                            }
                          }

                          if (text.isEmpty) return const SizedBox.shrink();

                          return Text(
                            text,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                        interval: yInterval,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(7, (index) {
                    final duration = dailyDurations[index];
                    final isToday = (index == now.weekday - 1);
                    final hasData = duration > 0;

                    final minHeight = maxY * 0.01;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: hasData ? duration.toDouble() : minHeight,
                          color: hasData
                              ? (isToday
                                    ? AppColors.primary
                                    : Colors.transparent)
                              : (isToday
                                    ? AppColors.primary
                                    : AppColors.primary.withValues(alpha: 0.5)),
                          width: barWidth,
                          borderRadius: hasData
                              ? BorderRadius.circular(12)
                              : BorderRadius.circular(4),
                          borderSide: hasData && !isToday
                              ? const BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                )
                              : BorderSide.none,
                          backDrawRodData: BackgroundBarChartRodData(
                            show: false,
                          ),
                        ),
                      ],
                      showingTooltipIndicators: hasData ? [0] : [],
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
