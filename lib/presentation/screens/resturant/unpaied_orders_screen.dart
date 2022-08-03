import 'package:deliverk/data/models/common/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../business_logic/restaurant/cubit/restaurants_current_orders_cubit.dart';
import '../../../business_logic/restaurant/state/restaurant_current_orders_state.dart';
import '../../widgets/restaurant/order_details_dialog.dart';
import '../../widgets/restaurant/unpaied_orders_model.dart';

class UnpaiedOrdersScreen extends StatelessWidget {
  UnpaiedOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<RestaurantCurrentOrdersCubit>(context)
        .loadOrders(isPaid: false);
    return Scaffold(
      body: SafeArea(child: _buildOrders(context)),
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
      body: _buildOrdersList(),
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

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 2),
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
                  child: const UnpaiedOrdersModel());
            } else {
              return _loadingIndicator();
            }
          },
          itemCount: orders.length + (isLoading ? 1 : 0),
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
              .loadOrders(isPaid: false);
        }
      }
    });
  }
}
