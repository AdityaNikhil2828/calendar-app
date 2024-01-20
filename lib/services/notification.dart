import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationManager {

    FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); //

  initializeNotification() async {
    //tz.initializeTimeZones();
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

 final AndroidInitializationSettings initializationSettingsAndroid =
     AndroidInitializationSettings("appicon");

    final InitializationSettings initializationSettings =
        InitializationSettings(
       iOS: initializationSettingsIOS,
       android:initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    else
     {
      print('Notification done');
     }
    Get.to(Container(color: Colors.white));
}

    Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    /*showDialog(
      //context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );
            },
          )
        ],
      ),
    );
  */
  Get.dialog(
    Text("Widget"),
  );
  }
}