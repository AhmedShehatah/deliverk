import 'package:deliverk/data/models/common/order_model.dart';
import 'package:flutter/material.dart';

class RecordItemModel extends StatelessWidget {
  const RecordItemModel(this.order, {Key? key}) : super(key: key);
  final OrderModel order;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Text(
                order.id.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          title: Text(order.delvId.toString()),
          trailing: Text(order.areaCost.toString()),
          subtitle: Text(order.resId.toString()),
        ),
      ),
    );
  }
}
