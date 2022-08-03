import 'dart:math';

import '../../../business_logic/common/cubit/spinner_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../constants/enums.dart';
import '../../widgets/common/spinner.dart';
import '../../widgets/common/text_field.dart';

class RestaurantNewOrder extends StatelessWidget {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _preparationController = TextEditingController();

  final int code = Random().nextInt(10000);

  RestaurantNewOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اضافة طلب"),
        centerTitle: true,
      ),
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
                    ["جاهز", "غير جاهز"],
                    SpinnerEnum.preparationTime,
                  ),
                ),
                Expanded(
                  child: _buildPaymentStatus(),
                ),
              ],
            ),

            /// logic
            _buildFields(context),
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

  Widget _buildFields(BuildContext context) {
    return BlocBuilder<SpinnerCubit, SpinnerState>(
      builder: (ctx, state) {
        Logger().d(state);
        if (state is SpinnerInitial) {
          Logger().d(state.paymentState);
          Logger().d(state.preparationState);
          if (state.paymentState == "غير مدفوع" &&
              state.preparationState == "غير جاهز") {
            Logger().d("Here I'm Brooooooo");
            return Row(
              children: [
                Expanded(child: _buildPreparationField()),
                Expanded(child: _buildPriceField()),
              ],
            );
          } else if (state.paymentState == "غير مدفوع") {
            return _buildPriceField();
          } else if (state.preparationState == "غير جاهز") {
            return _buildPreparationField();
          } else {
            return const Text('');
          }
        }
        Logger().d("I got here Brooooooooo");
        return const Text('');
      },
    );
  }

  Widget _buildPreparationField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CustomTextField(
        controller: _preparationController,
        hint: "مدة التجهيز",
        inputType: TextInputType.number,
      ),
    );
  }

  Widget _buildPriceField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CustomTextField(
        controller: _priceController,
        hint: "سعر الطلب",
        inputType: TextInputType.number,
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
