import '../../widgets/delivery/delivery_current_orders_model.dart';
import 'package:flutter/material.dart';
import '../../widgets/delivery/deliver_order_dilaog.dart';

class DeliveryCurrentOrdersScreen extends StatelessWidget {
  const DeliveryCurrentOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildOrders(context),
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
          delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              return InkWell(
                  onTap: () {
                    showDialog(
                        context: ctx,
                        builder: (c) => const DeliveryOrderDetialsDialog());
                  },
                  child: const DeliveryCurrentOrderModel());
            },
            childCount: 10,
          ),
        ),
      ],
    );
  }
}
