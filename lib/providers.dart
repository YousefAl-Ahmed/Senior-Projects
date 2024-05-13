import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seniorproject/API/fetch_data.dart';
import 'package:seniorproject/models/energy_data.dart';

final energyDataProvider = FutureProvider<EnergyData>((ref) async {
  ApiService apiService = ApiService();
  return apiService.loadData(
      "/Users/yousefalahmed/FlutterProjects/seniorproject/seniorproject/lib/backend/energy_data.csv");
});
