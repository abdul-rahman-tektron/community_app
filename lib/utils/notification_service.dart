import 'dart:convert';

import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

@pragma('vm:entry-point')
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  String? _pendingRoute;
  Map<String, dynamic>? _pendingExtraData;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  GlobalKey<NavigatorState>? _navigatorKey;

  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;

    // Handle pending notification click if any
    if (_pendingRoute != null) {
      _handleNotificationClick(_pendingRoute!, extraData: _pendingExtraData);
      _pendingRoute = null;
      _pendingExtraData = null;
    }
  }

  Future<void> init() async {
    debugPrint("[NotificationService] Initializing...");

    // Request permissions (iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint("[NotificationService] Permission status: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint("[NotificationService] Notifications are denied ❌");
      return;
    }

    // Get FCM/APNs token
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      _messaging.getAPNSToken().then((apnsToken) {
        debugPrint("[NotificationService] APNs Token: $apnsToken");
        _messaging.getToken().then((fcmToken) {
          debugPrint("[NotificationService] FCM Token: $fcmToken");
        });
      });
    } else {
      _messaging.getToken().then((fcmToken) {
        debugPrint("[NotificationService] FCM Token: $fcmToken");
      });
    }

    // Initialize local notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload != null && payload.isNotEmpty) {
          try {
            final Map<String, dynamic> data = jsonDecode(payload);
            final route = data['route'] ?? '';
            final extraData = data['extraData'] ?? {};
            _handleNotificationClick(route, extraData: Map<String, dynamic>.from(extraData));
          } catch (e) {
            debugPrint("[NotificationService] Failed to parse notification payload: $e");
          }
        }
      },
    );

    // Background messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("[NotificationService] onMessage received: ${message.messageId}");
      final notification = message.notification;
      if (notification != null) {
        _showLocalNotification(notification, message.data);
      }
    });

    // App opened from notification (background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("[NotificationService] App opened from notification: ${message.data}");
      // Extract route and extraData
      final route = message.data.keys.isNotEmpty ? message.data.keys.first : '';
      dynamic rawExtraData = message.data[route];
      Map<String, dynamic> extraData = {};

      if (rawExtraData is String) {
        try {
          extraData = Map<String, dynamic>.from(jsonDecode(rawExtraData));
        } catch (_) {
          extraData = {};
        }
      } else if (rawExtraData is Map) {
        extraData = Map<String, dynamic>.from(rawExtraData);
      }

      _handleNotificationClick(route, extraData: extraData);
    });

    debugPrint("[NotificationService] Initialization complete ✅");
  }

  Future<void> _showLocalNotification(
      RemoteNotification notification, Map<String, dynamic> data) async {
    final isEnabled = HiveStorageService.getNotification() ?? true;
    if (!isEnabled) return;

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    // Extract route and extraData
    final route = data.keys.isNotEmpty ? data.keys.first : '';
    dynamic rawExtraData = data[route];
    Map<String, dynamic> extraData = {};

    if (rawExtraData is String) {
      try {
        extraData = Map<String, dynamic>.from(jsonDecode(rawExtraData));
      } catch (_) {
        extraData = {};
      }
    } else if (rawExtraData is Map) {
      extraData = Map<String, dynamic>.from(rawExtraData);
    }

    // Encode route + extraData as payload
    final payload = jsonEncode({
      'route': route,
      'extraData': extraData,
    });

    await _localNotifications.show(
      0,
      notification.title,
      notification.body,
      platformDetails,
      payload: payload,
    );
  }

  Future<void> checkInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      final route = initialMessage.data['route'] ?? '';
      final extraData = initialMessage.data;
      _handleNotificationClick(route, extraData: extraData);
    }
  }

  void _handleNotificationClick(String route, {Map<String, dynamic>? extraData}) {
    if (_navigatorKey == null) {
      // App is not ready, save for later
      _pendingRoute = route;
      _pendingExtraData = extraData;
      return;
    }

    debugPrint("[NotificationService] Handling notification click. Route: $route, Data: $extraData");

    if (route == '/bookingDetails') {
      final bookingId = extraData?['bookingId'];
      _navigatorKey!.currentState?.pushNamed('/bookingDetails', arguments: bookingId);
    } else if (route == AppRoutes.vendorBottomBar) {
      _navigatorKey!.currentState?.pushNamed(AppRoutes.vendorBottomBar, arguments: extraData);
    } else if (route == '/requestDetails') {
      final requestId = extraData?['requestId'];
      _navigatorKey!.currentState?.pushNamed('/requestDetails', arguments: requestId);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint("[NotificationService] Background message received: ${message.messageId}, Data: ${message.data}");
  }
}