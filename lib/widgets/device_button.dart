import 'package:flutter/material.dart';

class DeviceButton extends StatelessWidget {
  final String label;
  final Widget destination;
  final Color buttonColor;

  const DeviceButton({
    Key? key,
    required this.label,
    required this.destination,
    this.buttonColor = const Color(0xff172E3C), // Default button color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Text(label),
      ),
    );
  }
}
