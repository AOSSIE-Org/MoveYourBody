import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:move_your_body/core/model/session_data.dart';
import 'package:move_your_body/core/theme/app_colors.dart';

class WeeklyCalorieChart extends StatelessWidget {
  final List<Session> allSessions;

  const WeeklyCalorieChart({super.key, required this.allSessions});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final dailyCalories = List<double>.filled(7, 0.0);

    for (var session in allSessions) {
      if (session.sessionStatus != SessionStatus.completed) continue;

      final date = session.createdAt;
      final sessionDate = DateTime(date.year, date.month, date.day);

      final difference = sessionDate.difference(startOfWeek).inDays;
      if (difference >= 0 && difference < 7) {
        dailyCalories[difference] += (session.caloriesBurned ?? 0.0);
      }
    }

    final maxCalorie = dailyCalories.reduce((a, b) => a > b ? a : b);
    final double maxY = maxCalorie > 0 ? maxCalorie * 1.3 : 20.0;

    final spots = List.generate(7, (index) {
      return FlSpot(index.toDouble(), dailyCalories[index]);
    });

    final gradientColors = [
      Colors.orangeAccent,
      Colors.deepOrange,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        RichText(
          text: const TextSpan(
            text: 'Calories burned this week ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: '(kcal)',
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
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
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
                        space: 10,
                        child: Text(text, style: style),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: maxY > 0 ? maxY / 4 : 100,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox.shrink();
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      );
                    },
                    reservedSize: 42,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 6,
              minY: 0,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  preventCurveOverShooting: true,
                  color: Colors.orangeAccent,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Colors.deepOrange,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: gradientColors
                          .map((color) => color.withValues(alpha: 0.3))
                          .toList(),
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => AppColors.surface,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final textStyle = const TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      );
                      return LineTooltipItem(
                        '${touchedSpot.y.toStringAsFixed(1)} kcal',
                        textStyle,
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
