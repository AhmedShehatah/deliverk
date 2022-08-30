import 'package:deliverk/presentation/screens/resturant/restaurant_base_screen.dart';
import 'package:deliverk/repos/restaurant/resturant_repo.dart';

import '../../../business_logic/common/cubit/area_cubit.dart';
import '../../../business_logic/restaurant/cubit/restaurant_login_cubit.dart';
import '../../../business_logic/restaurant/cubit/restaurant_profile_cubit.dart';
import '../../../constants/enums.dart';
import '../../../helpers/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../business_logic/restaurant/state/restaurant_login_state.dart';
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
          height: MediaQuery.of(context).size.height,
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
                  action: TextInputAction.next,
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<RestaurantLoginCubit, RestaurantLoginState>(
                  builder: (_, state) {
                    if (state is RestaurantLoginInitial) {
                      return _buildLoginButton(context);
                    } else if (state is LoadingState) {
                      return const CircularProgressIndicator(
                        color: Colors.blue,
                      );
                    } else if (state is SuccessState) {
                      WidgetsBinding.instance?.addPostFrameCallback((_) {
                        DeliverkSharedPreferences.setToken(state.token);
                        DeliverkSharedPreferences.setRestId(state.id);
                        DeliverkSharedPreferences.setZoneId(state.zoneId);
                        DeliverkSharedPreferences.setUserType(
                            UserType.restaurant.name);
                        Navigator.pushAndRemoveUntil<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  MultiBlocProvider(
                                    providers: [
                                      BlocProvider<ResturantProfileCubit>(
                                        create: (context) =>
                                            ResturantProfileCubit(
                                                RestaurantRepo()),
                                      ),
                                      BlocProvider<AreaCubit>(
                                          create: (_) => AreaCubit()),
                                    ],
                                    child: const RestaurantBaseScreen(),
                                  )),

                          (route) =>
                              false, //if you want to disable back feature set to false
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
        BlocProvider.of<RestaurantLoginCubit>(context).login(phone, password);
      },
      child: const Text("تسجيل الدخول"),
    );
  }
}
