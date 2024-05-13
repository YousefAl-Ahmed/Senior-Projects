import 'package:flutter/material.dart';
import 'package:seniorproject/API/fetch_data.dart';
import 'package:seniorproject/models/energy_data.dart';

class EnergyDataPage extends StatefulWidget {
  @override
  _EnergyDataPageState createState() => _EnergyDataPageState();
}

class _EnergyDataPageState extends State<EnergyDataPage> {
  EnergyData? _energyData;
  bool _isLoading = false;

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var data = await ApiService().loadData(
          '/Users/yousefalahmed/FlutterProjects/seniorproject/seniorproject/lib/backend/energy_data.csv');
      setState(() {
        _energyData = data;
      });
    } catch (e) {
      print('Failed to load data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Energy Data'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _energyData != null
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            'Predict Total Monthly Consumption Until Now: ${_energyData!.predictTotalMonthlyConsumptionUntilNow}'),
                        Text(
                            'Percentage Difference: ${_energyData!.percentageDifference}'),
                        Text(
                            'Total Consumption Today: ${_energyData!.totalConsumptionToday}'),
                        Text(
                            'Total Consumption This Month: ${_energyData!.totalConsumptionThisMonth}'),
                        Text(
                            'Average Consumption Per Hour: ${_energyData!.averageConsumptionPerHour}'),
                        Text(
                            'Daily Average Consumption For Last Week: ${_energyData!.dailyAverageConsumptionForLastWeek}'),
                        Text(
                            'Monthly Energy Consumption: ${_energyData!.monthlyEnergyConsumption}'),
                        Text('Outliers: ${_energyData!.outliers.join(", ")}'),
                      ],
                    ),
                  )
                : Center(
                    child: Text('No data loaded.'),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchData,
        tooltip: 'Load Data',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
