import 'package:flutter/material.dart';

import '../../../constants/strings.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
                width: double.infinity,
                height: 400,
                child: FadeInImage(
                  placeholder: AssetImage("assets/images/loading.gif"),
                  image: AssetImage("assets/images/logo.png"),
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: ElevatedButton(
                onPressed: () {
                  modalBottomSheet(context);
                },
                child: const Text("انضم الينا"),
              ),
            ),
            TextButton(
                onPressed: () {
                  modalBottomSheetLogin(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "هل لديك حساب ",
                      style: TextStyle(color: Colors.black),
                    ),
                    Text("سجل دخول"),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void modalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.0),
            topLeft: Radius.circular(25.0),
          ),
        ),
        builder: (ctx) {
          return SizedBox(
            height: 200,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    child: const Text("من فضلك اختر نوع الانضمام")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(
                          Icons.delivery_dining,
                          size: 60,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .popAndPushNamed(delivarySignUpRoute);
                          },
                          child: const Text("ديلفري"),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(
                          Icons.restaurant,
                          size: 60,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .popAndPushNamed(resturantSignUpRoute);
                          },
                          child: const Text("محل"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void modalBottomSheetLogin(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.0),
            topLeft: Radius.circular(25.0),
          ),
        ),
        builder: (ctx) {
          return SizedBox(
            height: 200,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(10),
                    child: const Text("من فضلك اختر نوع تسجيل الدخول")),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(
                          Icons.delivery_dining,
                          size: 60,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .popAndPushNamed(deliveryLoginRoute);
                          },
                          child: const Text("ديلفري"),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Icon(
                          Icons.restaurant,
                          size: 60,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .popAndPushNamed(restaurantLoginRoute);
                          },
                          child: const Text("محل"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
