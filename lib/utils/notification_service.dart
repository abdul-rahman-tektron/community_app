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
    debugPrint("[NotificationService] NavigatorKey set");
    _navigatorKey = navigatorKey;
  }

  Future<void> init() async {
    debugPrint("[NotificationService] Initializing...");

    await _messaging.requestPermission();
    debugPrint("[NotificationService] Permission requested");

    final token = await _messaging.getToken();
    debugPrint("[NotificationService] FCM Token: $token");

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint("[NotificationService] Local notification tapped with payload: ${details.payload}");
        final payload = details.payload;
        if (payload != null) {
          _handleNotificationClick(payload);
        }
      },
    );
    debugPrint("[NotificationService] Local notifications initialized");

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("[NotificationService] onMessage received: ${message.messageId}");
      final notification = message.notification;
      if (notification != null) {
        debugPrint("[NotificationService] Showing local notification with title: ${notification.title}, body: ${notification.body}");
        _showLocalNotification(notification, message.data);
      } else {
        debugPrint("[NotificationService] Message had no notification part");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("[NotificationService] App opened from notification. Route: ${message.data['route']}, Data: ${message.data}");
      _handleNotificationClick(message.data['route'] ?? '', extraData: message.data);
    });

    debugPrint("[NotificationService] Initialization complete ✅");
  }

  Future<void> _showLocalNotification(
      RemoteNotification notification,
      Map<String, dynamic> data,
      ) async {
    final isEnabled = HiveStorageService.getNotification() ?? true;
    debugPrint("[NotificationService] Notification setting: $isEnabled");

    if (isEnabled == false) {
      debugPrint("[NotificationService] Notifications muted. Skipping.");
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    debugPrint("[NotificationService] Triggering local notification...");
    await _localNotifications.show(
      0,
      notification.title,
      notification.body,
      platformDetails,
      payload: data['route'] ?? '',
    );
    debugPrint("[NotificationService] Local notification shown ✅");
  }

  void _handleNotificationClick(String route, {Map<String, dynamic>? extraData}) {
    debugPrint("[NotificationService] Handling notification click. Route: $route, Data: $extraData");

    if (_navigatorKey == null) {
      debugPrint("[NotificationService] NavigatorKey not set ❌");
      return;
    }

    if (route == '/bookingDetails') {
      final bookingId = extraData?['bookingId'];
      debugPrint("[NotificationService] Navigating to BookingDetails with bookingId: $bookingId");
      // _navigatorKey!.currentState?.pushNamed('/bookingDetails', arguments: bookingId);
    } else if (route == '/requestDetails') {
      final requestId = extraData?['requestId'];
      debugPrint("[NotificationService] Navigating to RequestDetails with requestId: $requestId");
      // _navigatorKey!.currentState?.pushNamed('/requestDetails', arguments: requestId);
    } else {
      debugPrint("[NotificationService] No matching route found for: $route");
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint("[NotificationService] Background message received: ${message.messageId}, Data: ${message.data}");
  }
}