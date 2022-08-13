import 'package:deliverk/data/models/delivery/zone_order.dart';
import 'package:logger/logger.dart';

abstract class DeliveryOrdersState {}

class DeliveryOrdersInit extends DeliveryOrdersState {}

class DeliveryOrdersLoaded extends DeliveryOrdersState {
  final List<ZoneOrder> currentOrders;
  DeliveryOrdersLoaded(this.currentOrders);
}

class DeliveryOrdersLoading extends DeliveryOrdersState {
  final List<ZoneOrder> oldOrders;
  final bool isFirstFetch;

  DeliveryOrdersLoading(this.oldOrders, {this.isFirstFetch = false}) {
    Logger().d(oldOrders.isEmpty);
  }
}

class DeliveryOrdersFailed extends DeliveryOrdersState {
  final String message;
  DeliveryOrdersFailed(this.message);
}
