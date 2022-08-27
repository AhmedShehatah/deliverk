import '../../../data/models/delivery/zone_order.dart';
// import 'package:logger/logger.dart';

abstract class ZoneOrdersState {}

class ZoneOrdersInit extends ZoneOrdersState {}

class ZoneOrdersLoaded extends ZoneOrdersState {
  final List<ZoneOrder> currentOrders;
  ZoneOrdersLoaded(this.currentOrders);
}

class ZoneOrdersLoading extends ZoneOrdersState {
  final List<ZoneOrder> oldOrders;
  final bool isFirstFetch;

  ZoneOrdersLoading(this.oldOrders, {this.isFirstFetch = false});
}

class ZoneOrdersFailed extends ZoneOrdersState {
  final String message;
  ZoneOrdersFailed(this.message);
}
