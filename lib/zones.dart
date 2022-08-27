import 'data/apis/zones_apis.dart';
import 'package:hive/hive.dart';

class Zones {
  Future getZones() async {
    Map<String, int> zones = {};
    await ZoneApi().getZones().then((response) async {
      if (response['success']) {
        final data = response['data'] as List<dynamic>;
        var box = await Hive.openBox<Map<String, int>>('zones');
        for (var element in data) {
          zones[element['name'] as String] = element['id'] as int;
        }

        box.put('zone', zones);
      } else {}
    });
  }
}
