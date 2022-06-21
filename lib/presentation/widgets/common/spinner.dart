import '../../../constants/enums.dart';
import '../../../helpers/providers/new_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Spinner extends StatelessWidget {
  const Spinner(this.hint, this.items, this.spinnerEnum, {Key? key})
      : super(key: key);
  final String hint;
  final List<String> items;
  final SpinnerEnum spinnerEnum;

  @override
  Widget build(BuildContext context) {
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
        hint: Text(hint),
        onChanged: (value) {
          if (value != null && spinnerEnum == SpinnerEnum.paymentState) {
            Provider.of<NewOrderProvider>(context, listen: false)
                .changeText(value);
          }
        },
        items: items.map((value) {
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
