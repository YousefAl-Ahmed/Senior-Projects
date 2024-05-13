import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seniorproject/widgets/line_graph.dart';
import 'package:seniorproject/widgets/pie_chart.dart';
import 'package:seniorproject/widgets/insights/insights_gridview_inner.dart';
import 'package:seniorproject/widgets/last_7days_daily_average.dart';

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          const Last7DaysDailyAverage(),
          Container(
            decoration: BoxDecoration(
              color: gridContainerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: const Column(
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
                Expanded(
                  child: LastSixHoursChart(),
                ),
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
                child: const MonthlyConsumptionPieChart(),
              ),
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
