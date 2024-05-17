import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void deviceOnOff(BuildContext context, String deviceOffOnMessage) async {
  try {
    var response = await http.post(
      Uri.parse(
          'http://192.168.100.19:80/deviceOffOn'), // Ensure this is your ESP server's IP and port
      body: {'deviceOffOnMessage': deviceOffOnMessage},
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Command sent successfully')),
      );
    } else {
      throw Exception('Failed to send command: ${response.body}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
