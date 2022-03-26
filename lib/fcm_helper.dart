import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:getx_project/local_notification_helper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  log('i have recived background message');
}

class FcmHelper {
  FcmHelper._() {
    getUserPermissions();
  }
  static FcmHelper fcmHelper = FcmHelper._();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  getUserPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  getDeviceToken() async {
    String? token = await messaging.getToken();
    log(token ?? 'not found');
  }

  runFcmInTheForeground() {
    getDeviceToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationHelper.localNotificationHelper.showNotification(
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          message.notification!.body.toString());
    });
  }

  runFcmInTheBackground() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
