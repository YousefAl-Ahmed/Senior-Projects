import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seniorproject/models/energy_data.dart';
import 'package:seniorproject/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seniorproject/widgets/line_graph.dart';
import 'package:seniorproject/widgets/pie_chart.dart';
import 'package:seniorproject/widgets/insights/insights_gridview_inner.dart';
import 'package:seniorproject/widgets/last_7days_daily_average.dart';

class DashboardGrid extends ConsumerWidget {
  final Last7DaysDailyAverage barChart;
  final LastSixHoursChart lineGraph;
  final MonthlyConsumptionPieChart pieChart;
  const DashboardGrid({
    super.key,
    required this.barChart,
    required this.lineGraph,
    required this.pieChart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const gridContainerColor = Color(0xffC7E3EC);

    return Expanded(
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 40,
        mainAxisSpacing: 40,
        crossAxisCount: 2,
        childAspectRatio: (450 / 400), // Width 450 / Height 350

        children: <Widget>[
          Container(
            //radius: 10,
            decoration: BoxDecoration(
              color: gridContainerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: const Column(
              children: [
                Text(
                  'Insights',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                InsightsGridviewInner(),
              ],
            ),
          ),
          barChart,
          Container(
            decoration: BoxDecoration(
              color: gridContainerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 8,
                  ), // Add some space below the header
                  child: Text(
                    'Average Electricity Consumption Per Hour',
                    style: TextStyle(
                      fontSize: 18, // Adjust font size as needed
                      fontWeight: FontWeight.bold,
                      color:
                          Colors.black, // Adjust the color to fit your design
                    ),
                  ),
                ),
                Expanded(child: lineGraph),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: gridContainerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: pieChart),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'This Month Consumption by percentage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
