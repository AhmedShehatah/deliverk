import 'package:deliverk/data/models/common/order_model.dart';
import 'package:logger/logger.dart';

abstract class DeliveryOrdersState {}

class DeliveryOrdersInit extends DeliveryOrdersState {}

class DeliveryOrdersLoaded extends DeliveryOrdersState {
  final List<OrderModel> currentOrders;
  DeliveryOrdersLoaded(this.currentOrders);
}

class DeliveryOrdersLoading extends DeliveryOrdersState {
  final List<OrderModel> oldOrders;
  final bool isFirstFetch;

  DeliveryOrdersLoading(this.oldOrders, {this.isFirstFetch = false}) {
    Logger().d(oldOrders.isEmpty);
  }
}

class DeliveryOrdersFailed extends DeliveryOrdersState {
  final String message;
  DeliveryOrdersFailed(this.message);
}
