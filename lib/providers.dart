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
  await for (var _ in Stream.periodic(
    const Duration(seconds: 1),
  )) {
    yield await apiService.loadData(
        "/Users/yousefalahmed/Desktop/Senior Project/new_Week_Electricity_Consumption_Data.csv");
  }
});

// final outlierListProvider =
//     StateNotifierProvider<OutlierListNotifier, List<dynamic>>((ref) {
//   return OutlierListNotifier([]);
// });

// class OutlierListNotifier extends StateNotifier<List<dynamic>> {
//   OutlierListNotifier(List<dynamic> initialOutliers) : super(initialOutliers);

//   void removeOutlier(int index) {
//     state = List.from(state)..removeAt(index);
//   }

//   void setOutliers(List<dynamic> outliers) {
//     state = outliers;
//   }
// }
