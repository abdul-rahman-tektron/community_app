import 'dart:async';
import 'dart:convert';

import 'package:Xception/core/model/common/login/register_token_request.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/firebase_options.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/storage/hive_storage.dart';
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

  // ADDED: keep a handle to the token refresh subscription
  StreamSubscription<String>? _tokenSub;

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

    // Ensure Firebase is ready if you call this from a background isolate
    // (safe to call even if already initialized)
    try {
      Firebase.app();
    } catch (_) {
      await Firebase.initializeApp();
    }

    // iOS foreground presentation options
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

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

    // Enable auto-init (in case it was disabled)
    await _messaging.setAutoInitEnabled(true);

    // ===== TOKEN: GET CURRENT & SEND TO BACKEND =====
    await _obtainAndSendCurrentToken();

    // ===== TOKEN: LISTEN FOR REFRESH & RESEND =====
    _tokenSub?.cancel();
    _tokenSub = _messaging.onTokenRefresh.listen((newToken) async {
      debugPrint("[NotificationService] onTokenRefresh -> $newToken");
      await _persistToken(newToken);
      await sendTokenToBackend(newToken);
    });

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

  // ADDED: call when you teardown the app (optional since singleton)
  Future<void> dispose() async {
    await _tokenSub?.cancel();
  }

  // ====== TOKEN HELPERS ======

  Future<void> _obtainAndSendCurrentToken() async {
    try {
      String? fcmToken;

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apns = await _messaging.getAPNSToken();
        debugPrint("[NotificationService] APNs Token: $apns");
        fcmToken = await _messaging.getToken();
      } else {
        fcmToken = await _messaging.getToken();
      }

      debugPrint("[NotificationService] FCM Token: $fcmToken");

      if (fcmToken != null && fcmToken.isNotEmpty) {
        // Avoid redundant sends if already sent/saved
        final lastSaved = HiveStorageService.getFCMToken();
        if (lastSaved != fcmToken) {
          await _persistToken(fcmToken);
          await sendTokenToBackend(fcmToken);
        }
      }
    } catch (e) {
      debugPrint("[NotificationService] Error obtaining token: $e");
    }
  }

  Future<void> _persistToken(String token) async {
    try {
      await HiveStorageService.setFCMToken(token);
    } catch (e) {
      debugPrint("[NotificationService] Error saving token locally: $e");
    }
  }

  /// ADDED: replace this with your real API integration.
  /// This mirrors:
  /// - iOS: Messaging.messaging().token {...}
  /// - Android: FirebaseMessaging.getInstance().getToken(), onNewToken(...)
  Future<void> sendTokenToBackend(String token) async {
    debugPrint("[NotificationService] Sending FCM token to backend...");
    // TODO: implement your actual API call here.
    // Example sketch:
    //
    // final userId = HiveStorageService.getUserId();
    // await ApiClient.post(
    //   "/notifications/register-token",
    //   body: {"userId": userId, "fcmToken": token, "platform": defaultTargetPlatform.name},
    // );
    //
    // Handle errors & retries as needed.
    debugPrint("[NotificationService] Token sent ✅");
  }

  // Future<void> apiRegisterToken(String token) async {
  //   String fcmToken = '';
  //
  //   try {
  //     // Get FCM token safely
  //     fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
  //     print("FCM Token: $fcmToken");
  //
  //     // Call your API with the token (empty string if null)
  //     final parsed = await CommonRepository.instance.apiRegisterToken(
  //       RegisterTokenRequest(
  //         userId: userNameController.text,
  //         token: fcmToken,
  //       ),
  //     );
  //   } catch (e, stackTrace) {
  //     print("❌ Error updating Token: $e");
  //     print("Stack: $stackTrace");
  //     ToastHelper.showError('An error occurred. Please try again.');
  //   } finally {
  //     notifyListeners();
  //   }
  // }


  // ====== NOTIFICATION DISPLAY & NAV ======

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
    try {
      Firebase.app();
    } catch (_) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    debugPrint("[NotificationService] Background message received: ${message.messageId}, Data: ${message.data}");
  }
}