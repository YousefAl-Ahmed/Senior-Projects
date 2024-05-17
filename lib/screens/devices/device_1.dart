import 'package:flutter/material.dart';
import 'package:seniorproject/widgets/alerts.dart';
import 'package:seniorproject/widgets/dashboard_grid.dart';

class Device1 extends StatelessWidget {
  const Device1({super.key});

  @override
  Widget build(BuildContext context) {
    //media query
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
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
          'Dashboard',
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
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Device1()),
                    );
                  },
                  child: const Text('Device 1'),
                ),
              ],
            ),
            const Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardGrid(),
                  Alerts(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
