import 'package:flutter/material.dart';

class DeliveryUnpaidOrdersModel extends StatelessWidget {
  const DeliveryUnpaidOrdersModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: const Card(
          elevation: 5,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 30,
              child: FittedBox(
                fit: BoxFit.cover,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "1234",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            title: Text("المطعم السوري"),
            subtitle: Text("150ج.م"),
          ),
        ),
      ),
    );
  }
}
