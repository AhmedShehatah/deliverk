import '../../widgets/restaurant/order_details_dialog.dart';

import '../../widgets/restaurant/current_orders_model.dart';
import 'package:flutter/material.dart';

import '../../widgets/restaurant/empty_orders.dart';

class RestaurantOrdersScreen extends StatelessWidget {
  RestaurantOrdersScreen({Key? key}) : super(key: key);
  final List<String> _list = [''];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _list.isEmpty ? const EmptyOrders() : _buildOrders(context),
      ),
    );
  }

  Widget _buildOrders(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          centerTitle: true,
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text('الطلبات الحالية'),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((ctx, i) {
            return InkWell(
                onTap: () {
                  showDialog(
                      context: ctx, builder: (c) => const OrderDetailsDialog());
                },
                child: const CurrentOrdersModel());
          }),
        ),
      ],
    );
  }
}
