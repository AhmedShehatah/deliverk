class TimeCalc {
  static int calcTime(String time) {
    final date = DateTime.tryParse(time);

    if (date != null) {
      return DateTime.now().difference(date).inMinutes;
    } else {}

    return 0;
  }
}
