import 'package:bloc/bloc.dart';
import 'package:deliverk/business_logic/delivery/state/delivery_order_state.dart';

import 'package:deliverk/data/models/delivery/zone_order.dart';

import 'package:deliverk/helpers/shared_preferences.dart';
import 'package:deliverk/repos/delivery/delivery_repo.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DeliveryOrdersCubit extends Cubit<DeliveryOrdersState> {
  DeliveryOrdersCubit(this._repo) : super(DeliveryOrdersInit());

  int page = 1;
  final DeliveryRepo _repo;

  void loadOrders({String? status, bool? isPaid}) {
    if (state is DeliveryOrdersLoading) return;
    final currentState = state;
    var oldOrders = <ZoneOrder>[];

    if (currentState is DeliveryOrdersLoaded) {
      oldOrders = currentState.currentOrders;
    }
    emit(DeliveryOrdersLoading(oldOrders, isFirstFetch: page == 1));

    var id = DeliverkSharedPreferences.getDelivId();

    Map<String, dynamic> querys = {};
    querys['page'] = '$page';
    querys['status'] = status;
    querys['isPaid'] = isPaid;
    _repo.getOrders(id!, querys).then((response) {
      if (response is DioError) {
        Logger().d(response);
        return;
      }
      if (response['success']) {
        page++;
        var x = response['data'] as List<dynamic>;
        final orders = (state as DeliveryOrdersLoading).oldOrders;
        var list = x.map((e) => ZoneOrder.fromJson(e)).toList();
        orders.addAll(list);
        emit(DeliveryOrdersLoaded(orders));
      } else {
        emit(DeliveryOrdersFailed(response['message']));
      }
    });
  }
}
