import '../../../business_logic/delivery/cubit/delivery_login_cubit.dart';
import '../../../business_logic/delivery/state/delivery_login_state.dart';
import '../../../constants/enums.dart';
import '../../../constants/strings.dart';
import '../../widgets/common/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../helpers/shared_preferences.dart';

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
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  inputType: TextInputType.phone,
                  controller: _phoneNumberController,
                  hint: 'رقم التلفون',
                  action: TextInputAction.next,
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
                BlocBuilder<DeliveryLoginCubit, DeliveryLoginState>(
                  builder: (_, state) {
                    if (state is DeliveryLoginInitial) {
                      return _buildLoginButton(context);
                    } else if (state is LoadingState) {
                      return const CircularProgressIndicator(
                        color: Colors.blue,
                      );
                    } else if (state is SuccessState) {
                      WidgetsBinding.instance?.addPostFrameCallback((_) {
                        DeliverkSharedPreferences.setToken(state.token);
                        DeliverkSharedPreferences.setDeliveryId(state.delivId);
                        DeliverkSharedPreferences.setZoneId(state.zoneId);
                        DeliverkSharedPreferences.setUserType(
                            UserType.delivery.name);
                        Navigator.popAndPushNamed(
                          context,
                          deliveryBaseScreen,
                        );
                        Fluttertoast.showToast(msg: "تم تسجيل الدخول بنجاح");
                      });

                      return const Text('');
                    } else {
                      Fluttertoast.showToast(msg: "فشل تسجيل الدخول");
                      return _buildLoginButton(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final phone = _phoneNumberController.text.toString();
        final password = _passwordController.text.toString();
        BlocProvider.of<DeliveryLoginCubit>(context).login(phone, password);
      },
      child: const Text("تسجيل الدخول"),
    );
  }
}
