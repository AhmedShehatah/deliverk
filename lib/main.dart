import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'constants/strings.dart';
import 'helpers/app_routers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        title: appName,
        locale: const Locale('eg', 'ar'),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter().onGenerateRoute,
        theme: ThemeData(
          primaryColor: MyColor().primaryColor,
          primaryColorLight: MyColor().primaryLightColor,
          primaryColorDark: MyColor().primaryDarkColor,
          fontFamily: "NotoKufiArabic",
        ),
      ),
    );
  }
}