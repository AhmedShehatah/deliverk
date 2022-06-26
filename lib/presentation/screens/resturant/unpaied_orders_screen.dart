import '../../widgets/restaurant/unpaied_orders_model.dart';
import 'package:flutter/material.dart';

import '../../widgets/restaurant/order_details_dialog.dart';

class UnpaiedOrdersScreen extends StatelessWidget {
  const UnpaiedOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildOrders(context)),
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
            title: Text('طلبات لم يتم تسليم حسابها'),
          ),
        ),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 2),
          delegate: SliverChildBuilderDelegate((ctx, i) {
            return InkWell(
                onTap: () {
                  showDialog(
                      context: ctx, builder: (c) => const OrderDetailsDialog());
                },
                child: const UnpaiedOrdersModel());
          }),
        ),
      ],
    );
  }
}
