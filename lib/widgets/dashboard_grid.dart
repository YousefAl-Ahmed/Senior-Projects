import 'package:flutter/material.dart';
import 'package:seniorproject/widgets/insights_gridview_inner.dart';

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
            child: const InsightsGridviewInner(),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: gridContainerColor,
            child:
                const Text('Monthly average', style: TextStyle(fontSize: 40)),
          ),
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
