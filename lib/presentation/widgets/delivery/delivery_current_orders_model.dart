import 'package:flutter/material.dart';

class DeliveryCurrentOrderModel extends StatelessWidget {
  const DeliveryCurrentOrderModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 5,
          child: SizedBox(
            height: 100,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildRestaurantPhoto(),
                const SizedBox(
                  width: 10,
                ),
                _buildDetials(),
                const Spacer(),
                Container(
                    padding: const EdgeInsets.all(10),
                    height: double.infinity,
                    child: const Text("23ج.م"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantPhoto() {
    return const ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
      child: SizedBox(
        width: 100,
        height: 100,
        child: FadeInImage(
          fit: BoxFit.cover,
          image: NetworkImage('https://picsum.photos/200/300'),
          placeholder: AssetImage('assets/images/loading.gif'),
        ),
      ),
    );
  }

  Widget _buildDetials() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text(
          "اسم المحل",
          style: TextStyle(fontSize: 13),
        ),
        Text(
          "جاهز",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const Text(
          "الجيزة- شارع السلام",
          style: TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
