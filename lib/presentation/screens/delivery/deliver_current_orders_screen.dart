import 'package:flutter/material.dart';

import '../../widgets/delivery/deliver_order_dilaog.dart';
import '../../widgets/delivery/delivery_current_orders_model.dart';

class DeliveryCurrentOrdersScreen extends StatefulWidget {
  const DeliveryCurrentOrdersScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryCurrentOrdersScreen> createState() =>
      _DeliveryCurrentOrdersScreenState();
}

class _DeliveryCurrentOrdersScreenState
    extends State<DeliveryCurrentOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildOrders(context),
    );
  }

  Future<void> refresh() async {}

  Widget _buildOrders(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: false,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (c) => const DeliveryOrderDetialsDialog());
              },
              child: const DeliveryCurrentOrderModel(),
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }
}
