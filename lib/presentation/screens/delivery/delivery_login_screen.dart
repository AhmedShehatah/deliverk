import 'package:deliverk/constants/strings.dart';
import 'package:deliverk/presentation/widgets/common/text_field.dart';
import 'package:flutter/material.dart';

class DeliveryLoginScreen extends StatelessWidget {
  DeliveryLoginScreen({Key? key}) : super(key: key);
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                inputType: TextInputType.phone,
                controller: _phoneNumberController,
                hint: 'رقم التلفون',
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                inputType: TextInputType.visiblePassword,
                controller: _passwordController,
                hint: 'كلمة المرور',
                secure: true,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, deliveryBaseScreen);
                },
                child: const Text("تسجيل الدخول"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
