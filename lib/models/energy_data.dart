import 'dart:convert';

class EnergyData {
  dynamic predictTotalMonthlyConsumptionUntilNow;
  dynamic percentageDifference;
  dynamic totalConsumptionToday;
  dynamic totalConsumptionThisMonth;
  Map<String, double> averageConsumptionPerHour;
  Map<String, double> dailyAverageConsumptionForLastWeek;
  dynamic monthlyEnergyConsumption;
  List<dynamic> outliers;

  EnergyData({
    required this.predictTotalMonthlyConsumptionUntilNow,
    required this.percentageDifference,
    required this.totalConsumptionToday,
    required this.totalConsumptionThisMonth,
    required this.averageConsumptionPerHour,
    required this.dailyAverageConsumptionForLastWeek,
    required this.monthlyEnergyConsumption,
    required this.outliers,
  });

  factory EnergyData.fromJson(Map<String, dynamic> json) {
    return EnergyData(
      predictTotalMonthlyConsumptionUntilNow:
          json['predict_total_monthly_consumption_until_now'],
      percentageDifference: json['percentage_difference'],
      totalConsumptionToday: json['total_consumption_today'],
      totalConsumptionThisMonth: json['total_consumption_this_month'],
      averageConsumptionPerHour: Map<String, double>.from(
          (jsonDecode(json['average_consumption_per_hour']) as Map).map(
              (key, value) => MapEntry(key, double.parse(value.toString())))),
      dailyAverageConsumptionForLastWeek: Map<String, double>.from((jsonDecode(
              json['daily_average_consumption_for_last_week']) as Map)
          .map((key, value) => MapEntry(key, double.parse(value.toString())))),
      monthlyEnergyConsumption: json['monthly_energy_consumption'],
      outliers: json['outliers'],
    );
  }
}
