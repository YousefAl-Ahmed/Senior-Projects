import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:seniorproject/models/energy_data.dart';
import 'package:seniorproject/providers.dart'; // Adjust path as necessary

class MonthlyConsumptionPieChart extends ConsumerStatefulWidget {
  const MonthlyConsumptionPieChart({Key? key}) : super(key: key);

  @override
  _MonthlyConsumptionPieChartState createState() =>
      _MonthlyConsumptionPieChartState();
}

class _MonthlyConsumptionPieChartState
    extends ConsumerState<MonthlyConsumptionPieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final asyncEnergyData = ref.watch(energyDataProvider);

    return asyncEnergyData.when(
      data: (data) {
        var jsonData = json.decode(
            data.monthlyEnergyConsumption); // Assuming it's a JSON string
        List<PieChartSectionData> sections = _createSections(jsonData);

        return AspectRatio(
          aspectRatio: 1.3,
          child: Row(
            children: <Widget>[
              Expanded(
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
                    sections: sections,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _createIndicators(jsonData),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stack) => Text('Error: $error'),
      loading: () => const CircularProgressIndicator(),
    );
  }

  List<PieChartSectionData> _createSections(Map<String, dynamic> jsonData) {
    List<String> devices = List<String>.from(jsonData['columns']);
    List<double> consumption = List<double>.from(jsonData['data'][0]);
    double total = consumption.fold(0, (sum, item) => sum + item);

    return List.generate(devices.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 18.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: Colors.primaries[index % Colors.primaries.length],
        value: consumption[index],
        title: '${(consumption[index] / total * 100).toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: isTouched ? Colors.black : Colors.white,
          shadows: const [Shadow(color: Colors.black, blurRadius: 3)],
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
