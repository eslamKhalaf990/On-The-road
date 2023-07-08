import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:on_the_road/view/notifications/notifications.dart';

// Future<void > handleBackMessage(RemoteMessage remoteMessage)async{
//
//   print("body: ${remoteMessage.notification?.body}");
//
// }
class Test{
  static initFirebase(BuildContext ctx)async{
    final firebase = FirebaseMessaging.instance;
    await firebase.requestPermission();
    final fcToken = await firebase.getToken();

    print("token: $fcToken");
    FirebaseMessaging.onMessage.listen((message) {
      print("object");
      showNotification(ctx, message.notification?.body.toString());
    });
  }
}