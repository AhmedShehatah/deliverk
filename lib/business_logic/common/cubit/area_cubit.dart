import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../../../data/apis/area_api.dart';
import '../state/generic_state.dart';

class AreaCubit extends Cubit<GenericState> {
  AreaCubit() : super(GenericStateInit());
  Map<int, String> areaId = {};
  Map<String, int> areaName = {};
  void loadAreas() {
    emit(GenericLoadingState());
    AreaApi().getAreas().then((response) async {
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
        emit(GenericSuccessState(data));
      } else {
        emit(GenericFailureState(response['message']));
      }
    });
  }
}
