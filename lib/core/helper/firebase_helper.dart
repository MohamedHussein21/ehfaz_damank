import 'dart:convert';
import 'dart:developer';

import 'package:ahfaz_damanak/core/helper/cash_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseHelper {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const String _lastNotificationKey = 'last_notification';

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  static Future<void> init() async {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: 'AIzaSyCAcTUR3szXDS9XJy59HBH-18rrzhLFD6s',
      appId: '1:419127283736:android:73dfcc511390d4a9b2f36d',
      messagingSenderId: '419127283736',
      projectId: 'eldamn-9e018',
    ));
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    log("🔑 FCM Token: $fcmToken");
    await CashHelper.saveData(key: 'googleToken', value: fcmToken);

    // sendTokenToBackend(fcmToken);

    await _initNotifications();
    await _setupFirebaseMessaging();
    await _checkForInitialMessage();
  }

  // static Future<void> sendTokenToBackend(String? token) async {
  //   if (token == null) return;

  //   final dio = Dio();

  //   try {
  //     final response = await dio.post(
  //       'https://your-backend.com/api/save-token',
  //       data: {
  //         'fcm_token': token,
  //       },
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token}',
  //           'Content-Type': 'application/json',
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       log(' FCM Token sent successfully');
  //     } else {
  //       log(' Failed to send FCM Token: ${response.statusMessage}');
  //     }
  //   } catch (e) {
  //     log(' Error sending FCM Token: $e');
  //   }
  // }

  static Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  static Future<void> _setupFirebaseMessaging() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleResumeMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    } else {
      await checkStoredNotificationData();
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    _showNotification(
      message.notification?.title,
      message.notification?.body,
      message.data,
    );
    _handleNotificationTap(json.encode(message.data));
  }

  static void _handleResumeMessage(RemoteMessage message) {
    print("Handling resume message: ${message.messageId}");
    _handleNotificationTap(
        json.encode({...message.data, 'title': message.notification?.title}));
  }

  static void _handleInitialMessage(RemoteMessage message) {
    print("Handling initial message: ${message.messageId}");
    _handleNotificationTap(
        json.encode({...message.data, 'title': message.notification?.title}));
  }

  static Future<void> _showNotification(
      String? title, String? body, Map<String, dynamic> data) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: json.encode({...data, 'title': title}),
    );
  }

  static Future<void> _storeNotificationData(String payload) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastNotificationKey, payload);
  }

  static Future<void> checkStoredNotificationData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPayload = prefs.getString(_lastNotificationKey);
    if (storedPayload != null) {
      _handleNotificationTap(storedPayload);
      await prefs.remove(_lastNotificationKey);
    }
  }

  static void _handleNotificationTap(String? payload) {
    if (payload != null) {
      final data = json.decode(payload);
      final title = data['title'] ?? 'No Title';
      final body = data['body'] ?? 'No Body';
      final route = data['route'] ?? '/home';

      navigatorKey.currentState?.pushNamed(route, arguments: {
        'title': title,
        'body': body,
      });
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
    _showNotification(
      message.notification?.title,
      message.notification?.body,
      message.data,
    );
  }

  // static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   await Firebase.initializeApp();
  //   print("📩 رسالة في الخلفية: ${message.messageId}");
  // }

  // static Future<void> initializeFirebaseMessaging() async {
  //   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // }
}
