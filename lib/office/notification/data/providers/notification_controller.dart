import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/routes/route_provider.dart';
import 'package:dazzles/office/notification/data/repo/set_notification_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
  // Do NOT show a notification manually here; Firebase handles it automatically
}

@pragma('vm:entry-point')
Future<void> onBackgroundNotificationResponse(
    NotificationResponse response) async {
  log("Background Notification Clicked: ${response.payload}");
  if (response.payload != null) {
    FirebasePushNotification.handleNotificationClick(response.payload!);
  }
}

class FirebasePushNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _notiToken;
  String? apiToken;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  Future<void> initNotification(BuildContext context) async {
    log('Requesting push notification permissions...');

    if (Platform.isAndroid || Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    await _initLocalNotification();
    await _getExistingToken(context);

    FirebaseMessaging.onMessage.listen((message) {
      log('Foreground Notification Received...');
      _showNotificationFromMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleNotificationClick(jsonEncode(event.data));
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        await Future.delayed(Duration(seconds: 3));
        handleNotificationClick(jsonEncode(message.data));
      }
    });
  }

  Future<void> _getExistingToken(BuildContext context) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        _notiToken = token;
        _updateTokenInDatabase(token, context);
      }

      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _notiToken = newToken;
        _updateTokenInDatabase(newToken, context);
      });

      log('FCM Token: ${_notiToken!}');

      if (Platform.isIOS) {
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        log("APNs Token: $apnsToken");
      }
    } catch (e) {
      log('Error getting FCM token: $e');
    }
  }

  void _updateTokenInDatabase(String newToken, BuildContext context) async {
    await SetNotificationRepo.setPushToken(newToken);
  }

  Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings androidInitialization =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitialization =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitialization, iOS: iosInitialization);

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
        log('Notification Clicked: ${response.payload}');

        handleNotificationClick(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationResponse,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  void _showNotificationFromMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _showNotification(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        payload: jsonEncode(message.data),
      );
    }
  }

  Future<void> _showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    _localNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        iOS: const DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          // 'channelId',
          // 'channelName',
          _androidChannel.id,
          _androidChannel.name,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
        ),
      ),
      payload: payload,
    );
  }

  static void handleNotificationClick(String? payload) {
    if (payload == null || payload.isEmpty) return;

    final data = jsonDecode(payload);
    _navigateToScreen(data);
  }

  static void _navigateToScreen(Map<String, dynamic> data) async {
    try {
      rootNavigatorKey.currentContext?.push(notificationScreen);
    } catch (e) {
      log('Navigation failed: $e');
    }
  }

  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
  }
}


// UPDATE TOKEN
// NAVIAGTIO FUNCTION