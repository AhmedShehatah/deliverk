import 'data/models/common/area_model.dart';
import 'helpers/firebase_notification_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'data/models/restaurant/restaurant_model.dart';
import 'helpers/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'constants/strings.dart';
import 'helpers/app_routers.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DeliverkSharedPreferences.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  Hive.registerAdapter(RestaurantModelAdapter());
  Hive.registerAdapter(AreaModelAdapter());
  await Hive.initFlutter();

  try {
    await Hive.box('areas').clear();
    await Hive.box('area_price').clear();
    // ignore: empty_catches
  } catch (e) {}
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));

  runApp(const MyApp());
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  dynamic data = message.data['data'];
  FirebaseNotifications.showNotification(data['title'], data['body']);
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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      firebaseNotifications.setUp(context);
    });
  }

  FirebaseNotifications firebaseNotifications = FirebaseNotifications();
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  // ignore: unnecessary_overrides
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }
}
