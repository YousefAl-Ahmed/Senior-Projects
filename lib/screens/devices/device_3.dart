import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seniorproject/providers.dart';
import 'package:seniorproject/widgets/alerts.dart';
import 'package:seniorproject/widgets/dashboard_grid.dart';
import 'package:seniorproject/widgets/devices_widgets/dashboard_grid.dart';
import 'package:seniorproject/widgets/devices_widgets/devices_barchart.dart';
import 'package:seniorproject/widgets/devices_widgets/line_graph.dart';
import 'package:seniorproject/widgets/devices_widgets/pie_chart.dart';
import 'package:seniorproject/widgets/line_graph.dart';
import 'package:seniorproject/widgets/pie_chart.dart';

class Device3 extends ConsumerWidget {
  const Device3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //media query
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final device3Data = ref.watch(device3DataProvider);

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
          'Device 3',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DeviceDashboardGrid(
                    data: device3Data,
                    barChart: DeviceLast7DaysDailyAverage(data: device3Data),
                    lineGraph: DeviceLastSixHoursChart(data: device3Data),
                    // pieChart:
                    //     DeviceMonthlyConsumptionPieChart(data: device1Data),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
