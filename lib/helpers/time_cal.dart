import 'package:logger/logger.dart';

class TimeCalc {
  final Logger _log = Logger();
  int calcTime(String time) {
    final date = DateTime.tryParse(time);
    _log.d(date);

    if (date != null) {
      return DateTime.now().difference(date).inMinutes;
    } else {
      _log.d('can not parse');
    }

    return 0;
  }
}
