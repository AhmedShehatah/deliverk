import 'package:bloc/bloc.dart';

import 'package:deliverk/data/models/delivery/zone_order.dart';
import 'package:deliverk/helpers/shared_preferences.dart';
import 'package:deliverk/repos/delivery/delivery_repo.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../state/delivery_zone_orders_state.dart';

class DeliveryZoneOrdersCubit extends Cubit<ZoneOrdersState> {
  DeliveryZoneOrdersCubit(this._repo) : super(ZoneOrdersInit());

  int page = 1;
  final DeliveryRepo _repo;
  final _log = Logger();

  void loadOrders({String? status, bool? isPaid}) {
    if (state is ZoneOrdersLoading) return;
    final currentState = state;
    var oldOrders = <ZoneOrder>[];

    if (currentState is ZoneOrdersLoaded) {
      _log.d('loaded bro');
      oldOrders = currentState.currentOrders;
    }
    emit(ZoneOrdersLoading(oldOrders, isFirstFetch: page == 1));

    var id = DeliverkSharedPreferences.getRestId();
    _log.d(id);
    Map<String, dynamic> querys = {};
    querys['page'] = '$page';
    querys['status'] = status;

    _repo.getZoneOrders(1, querys).then((response) {
      _log.d("I Got Here");
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
