import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/energy_data.dart'; // Assuming the model class is saved in a file named energy_data.dart

class ApiService {
  final String baseUrl = "http://127.0.0.1:5000";

  Future<EnergyData> loadData(String filepath) async {
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/load_data"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'filepath': filepath}),
      );
      if (response.statusCode == 200) {
        return EnergyData.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
