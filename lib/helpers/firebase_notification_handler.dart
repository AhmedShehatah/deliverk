import 'dart:io';

import 'shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

class FirebaseNotifications {
  FirebaseMessaging? _messaging;
  BuildContext? myContext;

  void setUp(BuildContext context) {
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessagingListener(context);
    myContext = context;
  }

  void firebaseCloudMessagingListener(BuildContext context) async {
    NotificationSettings seetings = await _messaging!.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      sound: true,
      provisional: false,
    );

    _messaging!.getToken().then((token) {
      DeliverkSharedPreferences.setFirebaseToken(token!);
      Logger()
          .d("Show me Token ${DeliverkSharedPreferences.getFirebaseToken()}");
    });
    _messaging!
        .subscribeToTopic('message')
        .whenComplete(() => Logger().d('subcirbe ok'));

    FirebaseMessaging.onMessage.listen((remoteMessage) {
      Logger().d('received this message: $remoteMessage');

      FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
        if (Platform.isIOS) {
          showDialog(
            context: myContext!,
            builder: ((context) => CupertinoAlertDialog(
                  title: Text(remoteMessage.notification!.title!),
                  content: Text(remoteMessage.notification!.body!),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text('ok'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    )
                  ],
                )),
          );
        }
      });

      if (Platform.isAndroid) {
        showNotification(
            remoteMessage.data['title'], remoteMessage.data['body']);
      } else if (Platform.isIOS) {
        showNotification(remoteMessage.notification!.title,
            remoteMessage.notification!.body);
      }
    });
  }

  static void showNotification(title, body) async {
    const androidChannel = AndroidNotificationDetails(
      'com.shehatah.deliverk',
      'new order',
      autoCancel: false,
      ongoing: true,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iOS = IOSNotificationDetails();
    const platform = NotificationDetails(android: androidChannel, iOS: iOS);
    await NotificationHandler.flutterLocalNotificationsPlugin
        .show(0, title, body, platform, payload: 'my payload');
  }
}

class NotificationHandler {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static BuildContext? myContext;

  static void initNotification(BuildContext context) {
    myContext = context;
    const initAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    const initIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const initSettings =
        InitializationSettings(android: initAndroid, iOS: initIOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  static void onSelectNotification(String? payload) {}

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    showDialog(
      context: myContext!,
      builder: ((context) => CupertinoAlertDialog(
            title: Text(title!),
            content: Text(body!),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('ok'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          )),
    );
  }
}
