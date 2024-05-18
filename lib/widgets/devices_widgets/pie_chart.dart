import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:seniorproject/models/energy_data.dart';
import 'package:seniorproject/providers.dart'; // Adjust path as necessary

class DeviceMonthlyConsumptionPieChart extends ConsumerStatefulWidget {
  final AsyncValue<Device> data;

  const DeviceMonthlyConsumptionPieChart({
    super.key,
    required this.data,
  });

  @override
  _DeviceMonthlyConsumptionPieChartState createState() =>
      _DeviceMonthlyConsumptionPieChartState();
}

class _DeviceMonthlyConsumptionPieChartState
    extends ConsumerState<DeviceMonthlyConsumptionPieChart> {
  AsyncValue<Device> get data => widget.data;
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return data.when(
      data: (data) {
        // var jsonData = json.decode(
        // data.monthlyEnergyConsumption); // Assuming it's a JSON string
        // List<PieChartSectionData> sections = _createSections(jsonData);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // children: _createIndicators(data),
              ),
            ),
            SizedBox(
              width: 250,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        setState(() {
                          touchedIndex = -1; // Reset touch
                        });
                        return;
                      }
                      setState(() {
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  // sections: sections,
                ),
              ),
            ),
          ],
        );
      },
      error: (error, stack) => Text('Error: $error'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  List<PieChartSectionData> _createSections(Map<String, dynamic> jsonData) {
    List<String> devices = List<String>.from(jsonData['columns']);
    List<double> consumption = List<double>.from(jsonData['data'][0]);
    double total = consumption.fold(0, (sum, item) => sum + item);

    return List.generate(devices.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 18.0 : 16.0;
      final radius = isTouched ? 100.0 : 80.0;

      return PieChartSectionData(
        color: Colors.primaries[index % Colors.primaries.length],
        value: consumption[index],
        title: '${(consumption[index] / total * 100).toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [
            Shadow(color: Colors.black, blurRadius: 3),
          ],
        ),
      );
    });
  }

  List<Widget> _createIndicators(Map<String, dynamic> jsonData) {
    List<String> devices = List<String>.from(jsonData['columns']);

    return List.generate(devices.length, (index) {
      return ListTile(
        leading: Icon(Icons.stop,
            color: Colors.primaries[index % Colors.primaries.length]),
        title: Text(devices[index]),
        visualDensity: VisualDensity.compact,
      );
    });
  }
}
