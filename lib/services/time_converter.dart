//convert time from 24 hour format to 12 hour format
String timeConvertor(String time) {
  int hour = int.parse(time);
  if (hour == 0) {
    return "12 AM";
  } else if (hour < 12) {
    return "$hour AM";
  } else if (hour == 12) {
    return "12 PM";
  } else {
    return "${hour - 12} PM";
  }
}
