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
          SizedBox(
            height: 150,
            width: 150,
            child: Image.asset(
              "assets/images/no_order.gif",
              fit: BoxFit.cover,
            ),
          ),
          const Text("لا توجد طلبات بعد")
        ],
      ),
    );
  }
}
