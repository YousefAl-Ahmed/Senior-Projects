import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seniorproject/API/fetch_data.dart';
import 'package:seniorproject/models/energy_data.dart';

// final energyDataProvider = FutureProvider<EnergyData>((ref) async {
//   ApiService apiService = ApiService();
//   return apiService.loadData(
//       "/Users/yousefalahmed/FlutterProjects/seniorproject/seniorproject/lib/backend/energy_data.csv");
// });

// Define the StreamProvider
final energyDataProvider = StreamProvider<EnergyData>((ref) async* {
  ApiService apiService = ApiService();
  // You might need to adjust the logic here to fit how often and when you want to fetch updates
  await for (var _ in Stream.periodic(Duration(seconds: 5))) {
    yield await apiService.loadData(
        "/Users/yousefalahmed/FlutterProjects/seniorproject/seniorproject/lib/backend/energy_data.csv");
  }
});
