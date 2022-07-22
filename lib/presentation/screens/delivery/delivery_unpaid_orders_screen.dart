import 'package:deliverk/presentation/widgets/delivery/delivery_unpaid_orders_model.dart';
import 'package:flutter/material.dart';

class DeliveryUnpaidOrdersScreen extends StatelessWidget {
  const DeliveryUnpaidOrdersScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildOrders(context),
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
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              return const DeliveryUnpaidOrdersModel();
            },
            childCount: 10,
          ),
        ),
      ],
    );
  }
}
