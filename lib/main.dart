import 'data/models/restaurant/restaurant_model.dart';
import 'helpers/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'constants/strings.dart';
import 'helpers/app_routers.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DeliverkSharedPreferences.init();
  Hive.registerAdapter(RestaurantModelAdapter());

  await Hive.initFlutter();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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
          fontFamily: "NotoKufiArabic",
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    Logger().d("closed baby");
  }
}
