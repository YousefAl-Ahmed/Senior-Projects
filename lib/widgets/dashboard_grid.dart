import 'package:flutter/material.dart';
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
            color: gridContainerColor,
            child: const Text('Hourly average', style: TextStyle(fontSize: 40)),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: gridContainerColor,
            child: const Text('Pie chart', style: TextStyle(fontSize: 40)),
          ),
        ],
      ),
    );
  }
}
