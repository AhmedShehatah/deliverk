import 'dart:async';

import '../../common/state/generic_state.dart';
import 'package:bloc/bloc.dart';
import '../../../data/models/common/order_model.dart';
import '../../../repos/restaurant/resturant_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AllOrdersCubit extends Cubit<GenericState> {
  AllOrdersCubit(this._repo) : super(GenericStateInit());

  final RestaurantRepo _repo;
  var orders = <OrderModel>[];
  void getAllOrders() {
    emit(GenericLoadingState());

    _repo.getOrdersAll().then((response) {
      if (response['success']) {
        var rawData = response['data'] as List<dynamic>;
        orders.clear();

        var data =
            rawData.map((element) => OrderModel.fromJson(element)).toList();
        orders.addAll(data);
        emit(GenericSuccessState(orders));
      } else {
        Logger().d(response['message']);
        emit(GenericFailureState(response['message']));
      }
    });
  }

  void checkUpdate() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _repo.getOrdersAll().then((response) {
        if (response['success']) {
          var rawData = response['data'] as List<dynamic>;
          var data =
              rawData.map((element) => OrderModel.fromJson(element)).toList();

          if (!listEquals(data, orders)) {
            orders = data;
            emit(GenericSuccessState(orders));
          }
        }
      });
    });
  }
}
