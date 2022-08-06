import 'package:deliverk/business_logic/restaurant/state/restaurant_current_orders_state.dart';
import 'package:deliverk/constants/enums.dart';
import 'package:deliverk/data/models/common/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../business_logic/restaurant/cubit/restaurants_current_orders_cubit.dart';
import '../../widgets/restaurant/current_orders_model.dart';

import '../../widgets/restaurant/order_details_dialog.dart';

class RestaurantOrdersScreen extends StatefulWidget {
  const RestaurantOrdersScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantOrdersScreen> createState() => _RestaurantOrdersScreenState();
}

class _RestaurantOrdersScreenState extends State<RestaurantOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<RestaurantCurrentOrdersCubit>(context)
        .loadOrders(status: OrderType.pending.name);
    return Scaffold(
      body: SafeArea(
        child: _buildOrders(context),
      ),
    );
  }

  Widget _buildOrders(BuildContext context) {
    return NestedScrollView(
        floatHeaderSlivers: false,
        headerSliverBuilder: (_, innerBoxIsScrolled) => [
              const SliverAppBar(
                pinned: true,
                centerTitle: true,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text('الطلبات الحالية'),
                ),
              ),
            ],
        body: _buildOrdersList());
  }

  final _log = Logger();
  Widget _buildOrdersList() {
    return BlocBuilder<RestaurantCurrentOrdersCubit, CurrentOrdersState>(
      builder: ((_, state) {
        if (state is CurrentOrdersLoading && state.isFirstFetch) {
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
                return InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (c) => OrderDetailsDialog(orders[index]));
                  },
                  child: CurrentOrdersModel(orders[index]),
                );
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

  Future<void> refresh(BuildContext context) async {
    BlocProvider.of<RestaurantCurrentOrdersCubit>(context)
        .loadOrders(status: OrderType.pending.name);
  }

  final _scrollController = ScrollController();

  void setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          BlocProvider.of<RestaurantCurrentOrdersCubit>(context)
              .loadOrders(status: OrderType.pending.name);
        }
      }
    });
  }
}
