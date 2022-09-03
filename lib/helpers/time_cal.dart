import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TimeCalc {
  static int calcTime(String time) {
    final date = DateTime.tryParse(time);

    if (date != null) {
      return DateTime.now().difference(date).inMinutes;
    } else {}

    return 0;
  }

  static Future<String> showTime(String time) async {
    await initializeDateFormatting("ar_SA", null);
    final date = DateTime.tryParse(time);
    var formatter = DateFormat.yMMMMEEEEd('ar_SA').add_jm();

    return formatter.format(date!);
  }
}
