class EnergyData {
  final String device;
  final int hour;
  final String date;
  final double value;
  final double lowerLimit;
  final double upperLimit;

  EnergyData({
    required this.device,
    required this.hour,
    required this.date,
    required this.value,
    required this.lowerLimit,
    required this.upperLimit,
  });

  factory EnergyData.fromJson(Map<String, dynamic> json) {
    return EnergyData(
      device: json['device'],
      hour: json['hour'],
      date: json['date'],
      value: json['value'].toDouble(),
      lowerLimit: json['lower_limit'].toDouble(),
      upperLimit: json['upper_limit'].toDouble(),
    );
  }
}
