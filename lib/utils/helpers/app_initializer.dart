import 'package:Xception/core/model/common/login/login_response.dart';
import 'package:Xception/firebase_options.dart';
import 'package:Xception/main.dart';
import 'package:Xception/res/colors.dart';
import 'package:Xception/utils/crashlytics_service.dart';
import 'package:Xception/utils/location_helper.dart';
import 'package:Xception/utils/notification_service.dart';
import 'package:Xception/utils/permissions_handler.dart';
import 'package:Xception/utils/storage/hive_storage.dart';
import 'package:Xception/utils/storage/secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _initializePermissions();
    await _initializeFirebase();
    await _initializeNotifications();
    await _initializeStorage();
    await _initializeLocation();
    await _setSystemUi();
    await _initializeCrashlytics();
  }

  static Future<void> _initializePermissions() async {
    await AppPermissionHandler.checkAndRequestLocation();
  }

  static Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<void> _initializeNotifications() async {
    // ⚡ Register the background handler first
    FirebaseMessaging.onBackgroundMessage(
        NotificationService.firebaseMessagingBackgroundHandler);

    // Then initialize the service (foreground & local notifications)
    await NotificationService().init();

    // Set navigatorKey for on-tap handling
    NotificationService().setNavigatorKey(MyApp.navigatorKey);

    //Handle the case when the app is opened from a terminated state
    await NotificationService().checkInitialMessage();
  }

  static Future<void> _initializeStorage() async {
    await Hive.initFlutter();
    await HiveStorageService.init();
    await SecureStorageService.init();
  }

  static Future<void> _initializeLocation() async {
    await LocationHelper.initialize();
  }

  static Future<void> _setSystemUi() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  static Future<void> _initializeCrashlytics() async {
    await CrashlyticsService.init();
  }

  /// Loads user token and option selection
  static Future<Map<String, dynamic>> loadUserData() async {
    final token = await SecureStorageService.getToken();
    final userJson = HiveStorageService.getUserData();
    final user = userJson != null ? loginResponseFromJson(userJson) : null;
    final optionSelection = HiveStorageService.getOptionSelectionCompleted();

    return {
      "token": token,
      "user": user,
      "optionSelectionCompleted": optionSelection,
    };
  }
}