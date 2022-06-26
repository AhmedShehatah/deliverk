import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrentOrdersModel extends StatelessWidget {
  const CurrentOrdersModel({Key? key}) : super(key: key);

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
                children: const [
                  Text("كود الطلب:123"),
                  Text(
                    "المنيب",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                  Text(
                    'قيد الانتظار',
                    style: TextStyle(
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
                children: const [
                  Text("23 جنيه"),
                  Icon(
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
