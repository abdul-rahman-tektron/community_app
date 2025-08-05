import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  GlobalKey<NavigatorState>? _navigatorKey;

  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  Future<void> init() async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();
    debugPrint("FCM Token: $token");

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle tap when app is in foreground (local notification)
        final payload = details.payload;
        if (payload != null) {
          _handleNotificationClick(payload);
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _showLocalNotification(notification, message.data);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message.data['route'] ?? '', extraData: message.data);
    });
  }


  Future<void> _showLocalNotification(
      RemoteNotification notification, Map<String, dynamic> data) async {

    final isEnabled = HiveStorageService.getNotification() ?? "true";
    if (isEnabled == "false") {
      debugPrint("Notifications are muted. Skipping notification.");
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      notification.title,
      notification.body,
      platformDetails,
      payload: data['route'] ?? '',
    );
  }

  void _handleNotificationClick(String route, {Map<String, dynamic>? extraData}) {
    if (_navigatorKey == null) return;

    // Example: Navigate based on route from notification
    if (route == '/bookingDetails') {
      final bookingId = extraData?['bookingId'];
      print(bookingId);
      // _navigatorKey!.currentState?.pushNamed('/bookingDetails',
      //     arguments: bookingId);
    } else if (route == '/requestDetails') {
      final requestId = extraData?['requestId'];
      print(requestId);
    }
    // Add more cases if needed
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint("Background message: ${message.messageId}");
  }
}
