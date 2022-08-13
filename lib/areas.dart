import 'package:deliverk/data/apis/area_api.dart';
import 'package:deliverk/helpers/shared_preferences.dart';

import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

class Areas {
  Map<int, String> areaId = {};
  Map<String, int> areaName = {};
  Future fetchAreas() async {
    await AreaApi().getAreas().then((response) async {
      if (response['success']) {
        var data = response['data'] as List<dynamic>;
        Logger().d(response['data']);
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

  Future getRestAreas() async {
    await AreaApi()
        .getRestAreas(DeliverkSharedPreferences.getRestId()!)
        .then((response) async {
      if (response['success']) {
        var data = response['data'] as List<dynamic>;
        Map<String, Map<String, int>> areaCost = {};
        var box =
            await Hive.openBox<Map<String, Map<String, int>>>('area_price');
        for (var element in data) {
          areaCost[element['area_name']] = {
            'cost': element['cost'],
            'id': element['area_id']
          };
        }
        box.put('cost', areaCost);
      }
    });
  }
}
