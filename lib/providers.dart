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
    const Duration(seconds: 2),
  )) {
    yield await apiService.loadData(
        "/Users/yousefalahmed/Desktop/Senior Project/new_Week_Electricity_Consumption_Data.csv");
  }
});
final device1DataProvider = StreamProvider<Device>((ref) async* {
  ApiService apiService = ApiService();
  await for (var _ in Stream.periodic(
    const Duration(seconds: 2),
  )) {
    yield await apiService.fetchDevice1Data();
  }
});
final device2DataProvider = StreamProvider<Device>((ref) async* {
  ApiService apiService = ApiService();
  await for (var _ in Stream.periodic(
    const Duration(seconds: 2),
  )) {
    yield await apiService.fetchDevice2Data();
  }
});
final device3DataProvider = StreamProvider<Device>((ref) async* {
  ApiService apiService = ApiService();
  await for (var _ in Stream.periodic(
    const Duration(seconds: 2),
  )) {
    yield await apiService.fetchDevice3Data();
  }
});
final device4DataProvider = StreamProvider<Device>((ref) async* {
  ApiService apiService = ApiService();
  await for (var _ in Stream.periodic(
    const Duration(seconds: 2),
  )) {
    yield await apiService.fetchDevice4Data();
  }
});

class EnergyDataNotifier extends StateNotifier<EnergyData> {
  EnergyDataNotifier(super.state);

  void removeOutlier(int index) {
    List<dynamic> updatedOutliers = List.from(state.outliers)..removeAt(index);
    state = state.copyWith(outliers: updatedOutliers);
  }
}


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
