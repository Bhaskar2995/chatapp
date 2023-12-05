import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notification',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print(
        'title-------------------------------------------------:${message.notification?.title}');
    print('body:${message.notification?.body}');
    print('payload:${message.data}');
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('token: $fcmToken');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      if (message.notification != null) {
        print('Notification Title: ${message.notification?.title}');
        print('Notification Body: ${message.notification?.body}');
      }
    });
  }
}
