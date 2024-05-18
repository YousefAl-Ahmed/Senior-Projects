import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seniorproject/models/energy_data.dart';
import 'package:seniorproject/widgets/devices_widgets/total_consumption_this_month.dart';

import 'this_month_prediction.dart';
import 'total_consumption_today.dart';
import 'yesterday_comparison.dart';

class DeviceInsightsGridviewInner extends StatelessWidget {
  final AsyncValue<Device> data;

  const DeviceInsightsGridviewInner({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        primary: false,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 40,
        mainAxisSpacing: 25,
        childAspectRatio: (185 / 125), // Width 450 / Height 350
        children: [
          DeviceThisMonthPrediction(data: data),
          DeviceYesterdayComparison(data: data),
          DeviceTotalConsumptionToday(data: data),
          DeviceTotalConsupmtionThisMonth(data: data),
        ],
      ),
    );
  }
}
