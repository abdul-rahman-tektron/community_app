import 'package:community_app/core/model/common/login/login_response.dart';
import 'package:community_app/firebase_options.dart';
import 'package:community_app/main.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/utils/crashlytics_service.dart';
import 'package:community_app/utils/location_helper.dart';
import 'package:community_app/utils/notification_service.dart';
import 'package:community_app/utils/permissions_handler.dart';
import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:community_app/utils/storage/secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
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
    await NotificationService().init();
    NotificationService().setNavigatorKey(MyApp.navigatorKey);
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