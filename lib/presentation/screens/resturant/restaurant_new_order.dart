import 'dart:math';

import '../../../constants/enums.dart';
import '../../../helpers/providers/new_order_provider.dart';
import '../../widgets/common/text_field.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../widgets/common/spinner.dart';

class RestaurantNewOrder extends StatelessWidget {
  final TextEditingController _priceController = TextEditingController();

  final int code = Random().nextInt(10000);

  RestaurantNewOrder({Key? key}) : super(key: key);

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
    var provider = Provider.of<NewOrderProvider>(context);
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildPlaceAutoFill(),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              width: double.infinity,
              child: const Text(
                "تكلفة التوصيل",
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              children: [
                const Expanded(
                  child: Spinner(
                    "مدة التحضير",
                    ["جاهز", "5 دقائق", "10 دقائق", "20 دقيقة", "نصف ساعه"],
                    SpinnerEnum.preparationTime,
                  ),
                ),
                Expanded(
                  child: _buildPaymentStatus(),
                ),
              ],
            ),
            if (provider.selectedState == "غير مدفوع")
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomTextField(
                  controller: _priceController,
                  hint: "سعر الطلب",
                  inputType: TextInputType.number,
                ),
              ),
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
    return const Spinner(
      "حالة الدفع",
      ["مدفوع", "غير مدفوع"],
      SpinnerEnum.paymentState,
    );
  }

  final List<String> _places = ["المنيب", "الجيزة", "رمسيس"];
  Widget _buildPlaceAutoFill() {
    return Autocomplete<String>(
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            label: const Text("المنطقة"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsBuilder: ((textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _places.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      }),
    );
  }
}
