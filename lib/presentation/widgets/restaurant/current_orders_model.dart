import 'package:deliverk/data/models/common/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrentOrdersModel extends StatelessWidget {
  const CurrentOrdersModel(this.orderModel, {Key? key}) : super(key: key);

  final OrderModel orderModel;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 5,
        child: Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("كود الطلب " + orderModel.id.toString()),
                  Text(
                    orderModel.areaId.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                  Text(
                    orderModel.status!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                  // SizedBox(child: Image.asset("assets/images/pendulum.gif"))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(orderModel.cost.toString() + "ج.م"),
                  const Icon(
                    CupertinoIcons.delete,
                    color: Colors.redAccent,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
