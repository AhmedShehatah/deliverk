import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../common/state/generic_state.dart';
import '../../../data/models/delivery/zone_order.dart';
import '../../../helpers/shared_preferences.dart';
import '../../../repos/delivery/delivery_repo.dart';

class DeliveryZoneOrdersCubit extends Cubit<GenericState> {
  DeliveryZoneOrdersCubit(this._repo) : super(GenericStateInit());

  final DeliveryRepo _repo;

  void loadOrders() {
    emit(GenericLoadingState());
    _repo
        .getZoneOrders(DeliverkSharedPreferences.getZoneId()!)
        .then((response) {
      if (response['success']) {
        var data = (response['data'] as List<dynamic>)
            .map((e) => ZoneOrder.fromJson(e))
            .toList();

        emit(GenericSuccessState(data));
      } else {
        emit(GenericFailureState(response['message']));
      }
    });
  }

  void checkNewOrders() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _repo
          .getZoneOrders(DeliverkSharedPreferences.getZoneId()!)
          .then((response) {
        if (response['success']) {
          var data = (response['data'] as List<dynamic>)
              .map((e) => ZoneOrder.fromJson(e))
              .toList();

          emit(GenericSuccessState(data));
        }
      });
    });
  }
}
