import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorproject/providers.dart';
import 'package:seniorproject/screens/devices/device_1.dart';
import 'package:seniorproject/screens/devices/device_2.dart';
import 'package:seniorproject/screens/devices/device_3.dart';
import 'package:seniorproject/screens/devices/device_4.dart';
import 'package:seniorproject/widgets/alerts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seniorproject/widgets/device_button.dart';
import 'package:seniorproject/widgets/last_7days_daily_average.dart';
import 'package:seniorproject/widgets/line_graph.dart';
import 'package:seniorproject/widgets/pie_chart.dart';

import '../widgets/dashboard_grid.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final totalEnergyData = ref.watch(energyDataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff172E3C),
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'SEMM',
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
            ),
          ),
        ),
        leadingWidth: width * 0.3,
        centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DeviceButton(label: 'Device 1', destination: Device1()),
                DeviceButton(label: 'Device 2', destination: Device2()),
                DeviceButton(label: 'Device 3', destination: Device3()),
                DeviceButton(label: 'Device 4', destination: Device4()),
              ],
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardGrid(
                    barChart: Last7DaysDailyAverage(data: totalEnergyData),
                    lineGraph: LastSixHoursChart(data: totalEnergyData),
                    pieChart: MonthlyConsumptionPieChart(data: totalEnergyData),
                  ),
                  Alerts(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
