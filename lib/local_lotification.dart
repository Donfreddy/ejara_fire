import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String appKey = '90296fa61203ccb7819c';
const String username = '';
const String cluster = 'eu';
const int id = 0;
const String payload = '';
const String eventName = 'test-event';
const String eventName2 = 'test-event2';
const String channelName = 'notification-$username';

class LocalNotification {
  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initializeNotifications() async {
    const initializeAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializeIOS = IOSInitializationSettings();
    const initSettings = InitializationSettings(android: initializeAndroid, iOS: initializeIOS);

    await localNotificationsPlugin.initialize(initSettings);
  }

  Future<void> singleNotification(String title, String body) async {
    const androidChannel = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFF3AD9F2),
      visibility: NotificationVisibility.public,
      enableVibration: false,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosChannel = IOSNotificationDetails();
    const platformChannel = NotificationDetails(android: androidChannel, iOS: iosChannel);

    await localNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannel,
      payload: payload,
    );
  }

  Future<void> cancelNotification() async {
    return await localNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    return await localNotificationsPlugin.cancelAll();
  }
}
