import '../../../data/models/delivery/zone_order.dart';

abstract class DeliveryOrdersState {}

class DeliveryOrdersInit extends DeliveryOrdersState {}

class DeliveryOrdersLoaded extends DeliveryOrdersState {
  final List<ZoneOrder> currentOrders;
  DeliveryOrdersLoaded(this.currentOrders);
}

class DeliveryOrdersLoading extends DeliveryOrdersState {
  final List<ZoneOrder> oldOrders;
  final bool isFirstFetch;

  DeliveryOrdersLoading(this.oldOrders, {this.isFirstFetch = false});
}

class DeliveryOrdersFailed extends DeliveryOrdersState {
  final String message;
  DeliveryOrdersFailed(this.message);
}
