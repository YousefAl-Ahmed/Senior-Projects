import 'package:flutter/material.dart';
import 'package:seniorproject/widgets/insights/total_consumption_this_month.dart';

import 'this_month_prediction.dart';
import 'total_consumption_today.dart';
import 'yesterday_comparison.dart';

class InsightsGridviewInner extends StatelessWidget {
  const InsightsGridviewInner({
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
        children: const [
          ThisMonthPrediction(),
          YesterdayComparison(),
          TotalConsumptionToday(),
          TotalConsupmtionThisMonth(),
        ],
      ),
    );
  }
}
