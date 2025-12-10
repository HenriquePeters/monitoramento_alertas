import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (payload) {
        
      },
    );

   
    const channel = AndroidNotificationChannel(
      'critical_alerts',
      'Critical Alerts',
      importance: Importance.max,
      description: 'Canal para alertas críticos',
    );
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> showAlert({
    required String title,
    required String body,
    bool critical = false,
    bool playSound = true,
    bool vibrate = true,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'critical_alerts',
      'Critical Alerts',
      channelDescription: 'Canal para alertas críticos',
      importance: Importance.max,
      priority: Priority.max,
      playSound: playSound,
      enableVibration: vibrate,
      fullScreenIntent: critical,
    );
    final details = NotificationDetails(android: androidDetails);
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: 'alert',
    );
  }
}
