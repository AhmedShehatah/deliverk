import 'package:flutter/material.dart';

class UnpaiedOrdersModel extends StatelessWidget {
  const UnpaiedOrdersModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 5,
        child: Container(
          height: 100,
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
                    "احمد شحاته",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                  Text("23 جنيه"),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () {},
                      child: const Icon(Icons.check),
                    ),
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
