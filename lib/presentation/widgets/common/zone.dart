import 'package:flutter/material.dart';

class Zone extends StatelessWidget {
  const Zone({Key? key}) : super(key: key);

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
        hint: const Text("المنطقة"),
        onChanged: (_) {},
        items: <String>["المنيب", "الجيزة", "رمسيس"].map((value) {
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
