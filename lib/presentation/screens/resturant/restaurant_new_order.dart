import 'dart:math';

import 'package:deliverk/presentation/widgets/common/text_field.dart';
import 'package:flutter/material.dart';

import '../../widgets/common/zone.dart';

class RestaurantNewOrder extends StatelessWidget {
  RestaurantNewOrder({Key? key}) : super(key: key);
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final int code = Random().nextInt(10000);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeaderPhoto(context),
              _buildOrderDetails(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderPhoto(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Image.asset("assets/images/new_order_header.png"),
    );
  }

  Widget _buildOrderDetails(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "كود الطلب $code",
              style: const TextStyle(
                  color: Color.fromARGB(150, 0, 0, 0), fontSize: 28),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(child: Zone()),
                Expanded(
                  child: Text(
                    "التكلفة",
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _priceController,
                      hint: "سعر الطلب",
                      inputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomTextField(
                        inputType: TextInputType.number,
                        controller: _timeController,
                        hint: "مدة التحضير بالدقائق"),
                  ),
                ],
              ),
            ),
            _buildPaymentStatus(),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: const Text(
                "اجمالي المبلغ: 20",
                textAlign: TextAlign.end,
              ),
            ),
            Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("اضافة"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatus() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        hint: const Text("حالة الدفع"),
        onChanged: (_) {},
        items: <String>["غير مدفوع", "مدفوع"].map((value) {
          return DropdownMenuItem<String>(
            value: value,
            alignment: AlignmentDirectional.centerEnd,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
