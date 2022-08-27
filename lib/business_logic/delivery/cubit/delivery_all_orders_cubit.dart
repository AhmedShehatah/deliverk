import 'dart:async';
import '../../common/state/generic_state.dart';
import 'package:bloc/bloc.dart';
import '../../../repos/delivery/delivery_repo.dart';
import 'package:logger/logger.dart';
import '../../../constants/enums.dart';
import '../../../data/models/delivery/zone_order.dart';
import '../../../helpers/shared_preferences.dart';

class DeliveryAllOrdersCubit extends Cubit<GenericState> {
  DeliveryAllOrdersCubit(this._repo) : super(GenericStateInit());
  final DeliveryRepo _repo;

  int page = 1;
  var orders = <ZoneOrder>[];
  void loadOrders({String? status, bool? isPaid}) {
    emit(GenericLoadingState());
    var id = DeliverkSharedPreferences.getDelivId();

    Map<String, dynamic> querys = {};
    querys['page'] = '$page';
    querys['status'] = status;
    querys['isPaid'] = isPaid;
    _repo.getOrders(id!, querys).then((response) {
      if (response['success']) {
        var x = response['data'] as List<dynamic>;

        var list = x.map((e) => ZoneOrder.fromJson(e)).toList();
        orders.clear();
        orders.addAll(list);

        emit(GenericSuccessState(orders));
      } else {
        emit(GenericFailureState(response['message']));
      }
    });
  }

  void update() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      var id = DeliverkSharedPreferences.getDelivId();

      Map<String, dynamic> querys = {};
      querys['page'] = '1';
      querys['status'] = OrderType.pending.name;

      _repo.getOrders(id!, querys).then((response) {
        if (response['success']) {
          var rawData = response['data'] as List<dynamic>;
          List<ZoneOrder> data =
              rawData.map((element) => ZoneOrder.fromJson(element)).toList();

          Logger().d(checkList(data, orders));
          if (!checkList(data, orders)) {
            orders = data;
            emit(GenericSuccessState(orders));
          }
        }
      });
    });
  }

  bool checkList(List<ZoneOrder> list1, List<ZoneOrder> list2) {
    if (list1.length != list2.length) {
      return false;
    } else {
      for (int i = 0; i < list1.length; i++) {
        if (list1[i].id != list2[i].id || list1[i].status != list2[i].status) {
          return false;
        }
      }
      return true;
    }
  }
}
