import 'package:bloc/bloc.dart';
import 'package:deliverk/business_logic/delivery/state/delivery_order_state.dart';
import 'package:deliverk/data/models/common/order_model.dart';

import 'package:deliverk/helpers/shared_preferences.dart';
import 'package:deliverk/repos/delivery/delivery_repo.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DeliveryOrdersCubit extends Cubit<DeliveryOrdersState> {
  DeliveryOrdersCubit(this._repo) : super(DeliveryOrdersInit());

  int page = 1;
  final DeliveryRepo _repo;
  final _log = Logger();

  void loadOrders({String? status, bool? isPaid}) {
    if (state is DeliveryOrdersLoading) return;
    final currentState = state;
    var oldOrders = <OrderModel>[];

    if (currentState is DeliveryOrdersLoaded) {
      _log.d('loaded bro');
      oldOrders = currentState.currentOrders;
    }
    emit(DeliveryOrdersLoading(oldOrders, isFirstFetch: page == 1));

    var id = DeliverkSharedPreferences.getRestId();
    _log.d(id);
    Map<String, dynamic> querys = {};
    querys['page'] = '$page';
    querys['status'] = status;

    _repo.getOrders(1, querys).then((response) {
      _log.d("I Got Here");
      if (response is DioError) {
        Logger().d(response);
        return;
      }
      if (response['success']) {
        page++;
        var x = response['data'] as List<dynamic>;
        final orders = (state as DeliveryOrdersLoading).oldOrders;
        var list = x.map((e) => OrderModel.fromJson(e)).toList();
        orders.addAll(list);
        emit(DeliveryOrdersLoaded(orders));
      } else {
        emit(DeliveryOrdersFailed(response['message']));
      }
    });
  }
}
