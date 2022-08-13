import 'package:bloc/bloc.dart';

import 'package:deliverk/data/models/delivery/zone_order.dart';
import 'package:deliverk/helpers/shared_preferences.dart';
// import 'package:deliverk/helpers/shared_preferences.dart';
import 'package:deliverk/repos/delivery/delivery_repo.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../state/delivery_zone_orders_state.dart';

class DeliveryZoneOrdersCubit extends Cubit<ZoneOrdersState> {
  DeliveryZoneOrdersCubit(this._repo) : super(ZoneOrdersInit());

  int page = 1;
  final DeliveryRepo _repo;

  void loadOrders({String? status, bool? isPaid}) {
    if (state is ZoneOrdersLoading) return;
    final currentState = state;
    var oldOrders = <ZoneOrder>[];

    if (currentState is ZoneOrdersLoaded) {
      oldOrders = currentState.currentOrders;
    }
    emit(ZoneOrdersLoading(oldOrders, isFirstFetch: page == 1));

    Map<String, dynamic> querys = {};
    querys['page'] = '$page';
    querys['status'] = status;

    _repo
        .getZoneOrders(DeliverkSharedPreferences.getZoneId()!, querys)
        .then((response) {
      if (response is DioError) {
        Logger().d(response);
        return;
      }
      if (response['success']) {
        page++;
        var x = response['data'] as List<dynamic>;
        final orders = (state as ZoneOrdersLoading).oldOrders;
        var list = x.map((e) => ZoneOrder.fromJson(e)).toList();
        orders.addAll(list);
        emit(ZoneOrdersLoaded(orders));
      } else {
        emit(ZoneOrdersFailed(response['message']));
      }
    });
  }
}
