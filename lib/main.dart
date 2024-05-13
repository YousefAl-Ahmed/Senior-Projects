import 'package:flutter/material.dart';
import 'package:seniorproject/screens/dashboard.dart';
import 'package:seniorproject/screens/test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//main function
void main() {
  runApp(ProviderScope(child: MyApp()));
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
      home: const DashboardScreen(),
    );
  }
}
