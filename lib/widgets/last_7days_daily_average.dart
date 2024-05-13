import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seniorproject/providers.dart';
import 'package:fl_chart/fl_chart.dart';

class Last7DaysDailyAverage extends ConsumerWidget {
  const Last7DaysDailyAverage({
    super.key,
  });
  final gridContainerColor = const Color(0xffC7E3EC);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final energyDataAsyncValue = ref.watch(energyDataProvider);
    return energyDataAsyncValue.when(
      loading: () => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: gridContainerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Text('Error: $err'),
      data: (energyData) {
        Map<String, double> data =
            energyData.dailyAverageConsumptionForLastWeek;
        final barGroups = data.entries.map((entry) {
          final date = DateTime.parse(entry.key);
          final energyConsumption = entry.value;
          final barRod = BarChartRodData(
            toY: energyConsumption,
            borderRadius: BorderRadius.circular(2),
          );
          return BarChartGroupData(
            x: date.millisecondsSinceEpoch,
            barRods: [barRod],
            showingTooltipIndicators: [],
          );
        }).toList();
        return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: gridContainerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: BarChart(
              BarChartData(
                maxY: //max value from the data
                    data.values.reduce((value, element) =>
                            value > element ? value : element) +
                        20,

                minY: 0, // Set minimum Y value
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        // Format the titles to show only selected y-values
                        if (value % 20 == 0) {
                          return Text('${value.toInt()}W');
                        }
                        return const Text('');
                      },
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final date =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return Text('${date.month}/${date.day}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14));
                      },
                      reservedSize: 32,
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Colors.grey,
                      strokeWidth: 0.5,
                    );
                  },
                  checkToShowHorizontalLine: (double value) {
                    return value % 20 ==
                        0; // Show horizontal grid lines at intervals of 20
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
                alignment: BarChartAlignment.spaceAround,
                // barTouchData: BarTouchData(
                //     enabled: false,
                //     touchTooltipData: BarTouchTooltipData(
                //         tooltipBgColor: Colors.blueGrey,
                //         getTooltipItem: (group, groupIndex, rod, rodIndex) {
                //           final dateString =
                //               DateTime.fromMillisecondsSinceEpoch(group.x)
                //                   .toString()
                //                   .substring(0, 10);
                //           return BarTooltipItem(
                //             '$dateString\n${rod.toY.toStringAsFixed(1)} kWh',
                //             const TextStyle(color: Colors.yellow),
                //           );
                //         })),
              ),
            ));
      },
    );
  }
}
