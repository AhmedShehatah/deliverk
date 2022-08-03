import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../business_logic/restaurant/cubit/restaurants_current_orders_cubit.dart';
import '../../../business_logic/restaurant/state/restaurant_current_orders_state.dart';
import '../../../constants/enums.dart';
import '../../../data/models/common/order_model.dart';
import '../../widgets/restaurant/record_item_model.dart';
import 'package:flutter/material.dart';

class RestaurantRecordScreen extends StatefulWidget {
  const RestaurantRecordScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantRecordScreen> createState() => _RestaurantRecordScreenState();
}

class _RestaurantRecordScreenState extends State<RestaurantRecordScreen> {
  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<RestaurantCurrentOrdersCubit>(context)
        .loadOrders(status: OrderType.received.name);
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل الطلبات المسلمة"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _buildOrdersList(),
      ),
    );
  }

  final _log = Logger();

  Widget _buildOrdersList() {
    return BlocBuilder<RestaurantCurrentOrdersCubit, CurrentOrdersState>(
      builder: ((_, state) {
        if (state is CurrentOrdersLoading && state.isFirstFetch) {
          _log.d('first fetch');
          return _loadingIndicator();
        }

        List<OrderModel> orders = [];
        bool isLoading = false;
        if (state is CurrentOrdersLoading) {
          _log.d(state.oldOrders);
          orders = state.oldOrders;
          isLoading = true;
        } else if (state is CurrentOrdersLoaded) {
          _log.d(state.currentOrders);
          orders = state.currentOrders;
        }

        return RefreshIndicator(
          onRefresh: () => refresh(context),
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (index < orders.length) {
                return const RecordItemModel();
              } else {
                return _loadingIndicator();
              }
            },
            itemCount: orders.length + (isLoading ? 1 : 0),
          ),
        );
      }),
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  final _scrollController = ScrollController();

  void setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          BlocProvider.of<RestaurantCurrentOrdersCubit>(context)
              .loadOrders(status: OrderType.received.name);
        }
      }
    });
  }

  Future<void> refresh(BuildContext context) async {
    BlocProvider.of<RestaurantCurrentOrdersCubit>(context).loadOrders();
  }
}
