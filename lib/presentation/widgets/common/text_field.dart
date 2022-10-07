import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField(
      {required this.inputType,
      required this.controller,
      required this.hint,
      this.secure,
      this.action,
      this.validator,
      Key? key})
      : super(key: key);
  final TextInputType inputType;
  final TextEditingController controller;
  final String hint;
  bool? secure = false;
  final String? validator;
  TextInputAction? action;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        keyboardType: inputType,
        minLines: 1,
        maxLines: secure == null ? null : 1,
        controller: controller,
        obscureText: secure == null ? false : secure!,
        decoration: InputDecoration(
          label: Text(hint),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
        textInputAction: action,
        validator: (value) {
          return validator;
        },
      ),
    );
  }
}
