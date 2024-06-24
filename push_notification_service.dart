import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Handle foreground messages here
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // Handle notification click
      });
    }
  }

  Future<void> sendNotification(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('http://your-flask-backend-url/generate_message'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String message = json.decode(response.body)['message'];

        await _fcm.send(RemoteMessage(
          notification: Notification(
            title: 'Screen Time Alert!',
            body: message,
          ),
          topic: userId,
        ));
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
