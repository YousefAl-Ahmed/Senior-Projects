import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:seniorproject/models/energy_data.dart'; // Adjust path as necessary
import 'dart:math' as math;

import 'package:seniorproject/providers.dart';

class DeviceLastSixHoursChart extends ConsumerWidget {
  final AsyncValue<Device> data;
  const DeviceLastSixHoursChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color lineColor = Color(0xff172E3C);

    return data.when(
      data: (Device data) {
        List<FlSpot> spots = _createSpotsFromData(data);
        double minY = data.averageConsumptionPerHour.values
            .fold(double.infinity, math.min);
        double maxY = data.averageConsumptionPerHour.values.fold(0, math.max);

        // Ensure there's space above the highest and below the lowest data points
        minY = (minY.floor() - 1).toDouble();
        maxY = (maxY.ceil() + 1).toDouble();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: LineChart(LineChartData(
            minY: minY,
            maxY: maxY,
            gridData: const FlGridData(show: true),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval: 1,
                  getTitlesWidget: _bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  interval: 1,
                  getTitlesWidget: _leftTitleWidgets,
                ),
              ),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: lineColor,
                barWidth: 5,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData:
                    BarAreaData(show: true, color: lineColor.withOpacity(0.3)),
              ),
            ],
          )),
        );
      },
      error: (error, stack) => Text('Error: $error'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text('${value.toInt()}:00', style: style),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    return Text('${value.toStringAsFixed(1)}W',
        style: style, textAlign: TextAlign.left);
  }

  List<FlSpot> _createSpotsFromData(Device data) {
    List<MapEntry<String, double>> entries =
        data.averageConsumptionPerHour.entries.toList();
    if (entries.length > 6) {
      entries = entries.sublist(entries.length - 6); // Only last 6 hours
    }

    return entries.map((entry) {
      double hour = double.parse(entry.key.split(":")[0]);
      return FlSpot(hour, entry.value);
    }).toList();
  }
}
