import 'package:deliverk/data/apis/area_api.dart';

import 'package:hive/hive.dart';

class Areas {
  Map<int, String> areaId = {};
  Map<String, int> areaName = {};
  void fetchAreas() {
    AreaApi().getAreas().then((response) async {
      if (response['success']) {
        var data = response['data'] as List<dynamic>;

        var box = await Hive.openBox<Map<dynamic, dynamic>>('areas');
        for (var element in data) {
          areaId[element['id']] = element['name'];
          areaName[element['name']] = element['id'];
        }

        box.put('areas_id', areaId);

        box.put('areas_name', areaName);
      }
    });
  }
}
