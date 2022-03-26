import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:getx_project/fcm_helper.dart';
import 'package:getx_project/local_notification_helper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  LocalNotificationHelper.localNotificationHelper.showNotification(
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      message.notification!.body.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  LocalNotificationHelper.localNotificationHelper.initLocalNotification();
  await Firebase.initializeApp();
  await FcmHelper.fcmHelper.runFcmInTheForeground();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: RaisedButton(onPressed: () {
          LocalNotificationHelper.localNotificationHelper
              .showNotification('title', 'body', 'payload');
        }),
      ),
    );
  }
}
