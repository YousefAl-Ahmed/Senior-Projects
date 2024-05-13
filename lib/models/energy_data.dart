class EnergyData {
  double predictTotalMonthlyConsumptionUntilNow;
  double percentageDifference;
  double totalConsumptionToday;
  double totalConsumptionThisMonth;
  String averageConsumptionPerHour;
  dynamic dailyAverageConsumptionForLastWeek;
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
      averageConsumptionPerHour: json['average_consumption_per_hour'],
      dailyAverageConsumptionForLastWeek:
          json['daily_average_consumption_for_last_week'],
      monthlyEnergyConsumption: json['monthly_energy_consumption'],
      outliers: json['outliers'],
    );
  }
}
