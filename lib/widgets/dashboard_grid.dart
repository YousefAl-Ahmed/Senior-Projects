import 'package:flutter/material.dart';
import 'package:seniorproject/widgets/insights_gridview_inner.dart';
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
                InsightsGridviewInner(),
              ],
            ),
          ),
          //Yousef
          Last7DaysDailyAverage(),
          //Jawad
          Container(
            padding: const EdgeInsets.all(8),
            color:
                gridContainerColor, // Make sure this color is defined somewhere in your project
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8), // Add some space below the header
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
          Container(
            padding: const EdgeInsets.all(8),
            color: gridContainerColor,
            child: MonthlyConsumptionPieChart(),
          ),
        ],
      ),
    );
  }
}
