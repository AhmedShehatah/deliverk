import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {required this.inputType,
      required this.controller,
      required this.hint,
      Key? key})
      : super(key: key);
  final TextInputType inputType;
  final TextEditingController controller;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        keyboardType: inputType,
        controller: controller,
        decoration: InputDecoration(
          label: Text(hint),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
