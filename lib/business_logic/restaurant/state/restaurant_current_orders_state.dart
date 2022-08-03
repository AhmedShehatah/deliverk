import 'package:deliverk/data/models/common/order_model.dart';
import 'package:logger/logger.dart';

abstract class CurrentOrdersState {}

class CurrentOrdersInit extends CurrentOrdersState {}

class CurrentOrdersLoaded extends CurrentOrdersState {
  final List<OrderModel> currentOrders;
  CurrentOrdersLoaded(this.currentOrders);
}

class CurrentOrdersLoading extends CurrentOrdersState {
  final List<OrderModel> oldOrders;
  final bool isFirstFetch;

  CurrentOrdersLoading(this.oldOrders, {this.isFirstFetch = false}) {
    Logger().d(oldOrders.isEmpty);
  }
}

class CurrentOrdersFailed extends CurrentOrdersState {
  final String message;
  CurrentOrdersFailed(this.message);
}
