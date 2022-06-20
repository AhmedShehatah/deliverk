import '../../widgets/restaurant/empty_orders.dart';
import 'package:flutter/material.dart';

class RestaurantOrdersScreen extends StatelessWidget {
  RestaurantOrdersScreen({Key? key}) : super(key: key);
  final List<String> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _list.isEmpty ? const EmptyOrders() : _buildOrders(),
      ),
    );
  }

  Widget _buildOrders() {
    return ListView.builder(
      itemBuilder: ((context, index) {
        return Text(
          _list[index],
          style: const TextStyle(color: Colors.amber),
        );
      }),
      itemCount: _list.length,
    );
  }
}
