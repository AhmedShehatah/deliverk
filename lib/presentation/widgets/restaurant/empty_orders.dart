import 'package:flutter/material.dart';

class EmptyOrders extends StatelessWidget {
  const EmptyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          Image.asset(
            "assets/images/no_orders.png",
            fit: BoxFit.cover,
          ),
          const Text("لا توجد طلبات بعد")
        ],
      ),
    );
  }
}
