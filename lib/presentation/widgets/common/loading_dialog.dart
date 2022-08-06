import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/loading.gif',
            scale: 100,
          ),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("جاري التحميل...")),
        ],
      ),
    );
  }
}
