import 'package:flutter/material.dart';

import '../../../constants/strings.dart';
import '../../widgets/common/text_field.dart';

class RestaurantLoginScreen extends StatelessWidget {
  RestaurantLoginScreen({Key? key}) : super(key: key);

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
                  Navigator.pushReplacementNamed(
                      context, restaurantBaseScreenRoute);
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
