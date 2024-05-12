class EnergyData {
  double predictTotalMonthlyConsumptionUntilNow;
  double percentageDifference;
  double totalConsumptionToday;
  double totalConsumptionThisMonth;
  double averageConsumptionPerHour;
  double dailyAverageConsumptionForLastWeek;
  double monthlyEnergyConsumption;
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
          json['predict_total_monthly_consumption_until_now'].toDouble(),
      percentageDifference: json['percentage_difference'].toDouble(),
      totalConsumptionToday: json['total_consumption_today'].toDouble(),
      totalConsumptionThisMonth:
          json['total_consumption_this_month'].toDouble(),
      averageConsumptionPerHour:
          json['average_consumption_per_hour'].toDouble(),
      dailyAverageConsumptionForLastWeek:
          json['daily_average_consumption_for_last_week'].toDouble(),
      monthlyEnergyConsumption: json['monthly_energy_consumption'].toDouble(),
      outliers: json['outliers'],
    );
  }
}
