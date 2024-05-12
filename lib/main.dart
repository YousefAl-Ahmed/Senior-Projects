import 'package:flutter/material.dart';
import 'package:seniorproject/screens/dashboard.dart';
import 'package:seniorproject/screens/test.dart';

//main function
void main() {
  runApp(MyApp());
}

//dummy app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EnergyDataPage(),
    );
  }
}
