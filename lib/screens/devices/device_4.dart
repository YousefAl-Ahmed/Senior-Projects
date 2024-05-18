import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seniorproject/providers.dart';
import 'package:seniorproject/widgets/devices_widgets/dashboard_grid.dart';
import 'package:seniorproject/widgets/devices_widgets/devices_barchart.dart';
import 'package:seniorproject/widgets/devices_widgets/line_graph.dart';

class Device4 extends ConsumerWidget {
  const Device4({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //media query
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final device4Data = ref.watch(device4DataProvider);
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
          'Device 4',
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
                    data: device4Data,
                    barChart: DeviceLast7DaysDailyAverage(data: device4Data),
                    lineGraph: DeviceLastSixHoursChart(data: device4Data),
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
