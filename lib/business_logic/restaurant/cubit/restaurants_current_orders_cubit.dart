import 'package:deliverk/business_logic/restaurant/state/restaurant_current_orders_state.dart';
import 'package:bloc/bloc.dart';
import 'package:deliverk/data/models/common/order_model.dart';
import 'package:deliverk/helpers/shared_preferences.dart';
import 'package:deliverk/repos/restaurant/resturant_repo.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class RestaurantCurrentOrdersCubit extends Cubit<CurrentOrdersState> {
  RestaurantCurrentOrdersCubit(this._repo) : super(CurrentOrdersInit());

  int page = 1;
  final RestaurantRepo _repo;

  void loadOrders({String? status, bool? isPaid}) {
    if (state is CurrentOrdersLoading) return;

    final currentState = state;
    var oldOrders = <OrderModel>[];

    if (currentState is CurrentOrdersLoaded) {
      oldOrders = currentState.currentOrders;
    }
    emit(CurrentOrdersLoading(oldOrders, isFirstFetch: page == 1));

    var id = DeliverkSharedPreferences.getRestId();
    if (id == null) {
      emit(CurrentOrdersFailed('الرجاء اعادة تسجيل الدخول'));
      return;
    }
    Map<String, dynamic> querys = {};
    querys['page'] = '$page';
    querys['status'] = status;
    querys['isPaid'] = isPaid;
    _repo.getOrders(querys, id).then((response) {
      if (response is DioError) {
        Logger().d(response);
        return;
      }
      if (response['success']) {
        page++;
        var x = response['data'] as List<dynamic>;
        final orders = (state as CurrentOrdersLoading).oldOrders;
        var list = x.map((e) => OrderModel.fromJson(e)).toList();
        orders.addAll(list);
        emit(CurrentOrdersLoaded(orders));
      } else {
        emit(CurrentOrdersFailed(response['message']));
      }
    });
  }
}
