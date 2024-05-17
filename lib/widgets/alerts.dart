import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seniorproject/providers.dart';
import 'package:seniorproject/services/device_on_off.dart';
import 'package:seniorproject/services/time_converter.dart';

class Alerts extends ConsumerStatefulWidget {
  const Alerts({Key? key}) : super(key: key);

  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends ConsumerState<Alerts> {
  List<dynamic> _outliers = [];
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    // Initialize the timer to update the list every 10 minutes
    _updateTimer = Timer.periodic(
        const Duration(minutes: 60), (Timer t) => _fetchLatestOutliers());
  }

  @override
  void dispose() {
    _updateTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _fetchLatestOutliers() {
    // Trigger an update on the widget with the latest data from the provider
    final currentData = ref.read(energyDataProvider);
    currentData.whenData((value) {
      setState(() {
        _outliers = List.from(value.outliers);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final energyDataAsyncValue = ref.watch(energyDataProvider);

    return energyDataAsyncValue.when(
      loading: () => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffC7E3EC),
            borderRadius: BorderRadius.circular(12),
          ),
          width: width * 0.25,
          height: height * 0.80,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (err, stack) => Text('Error: $err'),
      data: (energyData) {
        // Only update the local state immediately on initial load, later updates are managed by the timer ########################################
        // if (_outliers.isEmpty) {
        //   _outliers = List.from(energyData.outliers);
        // }
        return _buildOutliersList(width, height);
      },
    );
  }

  Widget _buildOutliersList(double width, double height) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffC7E3EC),
          borderRadius: BorderRadius.circular(12),
        ),
        width: width * 0.25,
        height: height * 0.80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Alerts",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _outliers.length,
                itemBuilder: (context, index) {
                  return _buildListItem(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(int index) {
    var outlier = _outliers[index];
    double upperLimit = outlier['upper_limit'];
    double value = outlier['value'];
    double percentageAboveUpperLimit = (value / upperLimit) * 100;

    String message = upperLimit < 5
        ? "Is ON in unusual time"
        : "Is consuming ${percentageAboveUpperLimit.toStringAsFixed(1)}% more than usual";
    String turnOffMessage = "Do you want to turn it off?";

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 110,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                "${outlier['device']} $message. $turnOffMessage",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _removeOutlier(index);
                      // removeDevice(context, outlier['device']);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Turn Off",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 22,
          child: Text(timeConvertor(outlier['hour'].toString()),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              )),
        ),
      ],
    );
  }

  void _removeOutlier(int index) {
    setState(() {
      _outliers.removeAt(index);
    });
  }
}
