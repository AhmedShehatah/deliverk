import 'package:flutter/material.dart';

class RecordItemModel extends StatelessWidget {
  const RecordItemModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Text(
                "123",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          title: Text("احمد شحاته"),
          trailing: Text("120ج.م"),
          subtitle: Text("المنيب شارع احمد فيصل"),
        ),
      ),
    );
  }
}
