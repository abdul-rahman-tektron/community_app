import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CrashlyticsService {
  CrashlyticsService._();

  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  static bool _initialized = false;

  /// Initialize Crashlytics and set common keys
  static Future<void> init() async {
    FlutterError.onError = _crashlytics.recordFlutterError;
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

    // Add app info
    final info = await PackageInfo.fromPlatform();
    await _crashlytics.setCustomKey("app_version", info.version);
    await _crashlytics.setCustomKey("build_number", info.buildNumber);
    await _crashlytics.setCustomKey("platform", Platform.operatingSystem);
    await _crashlytics.setCustomKey("build_mode", kDebugMode ? "debug" : kReleaseMode ? "release" : "profile");

    _initialized = true;
  }

  /// Wrap the app for catching async errors
  static Future<void> runWithCrashlytics(Future<void> Function() appRunner) async {
    await runZonedGuarded<Future<void>>(
      appRunner,
          (error, stack) => recordError(error, stack, reason: "Uncaught zone error"),
    );
  }

  /// Record handled exception with detailed context
  static Future<void> recordError(
      dynamic error,
      StackTrace stack, {
        String? className,
        String? reason,
        Map<String, dynamic>? context,
        bool fatal = false,
      }) async {
    if (!_initialized) return;

    if (className != null) await _crashlytics.setCustomKey("class", className);
    if (reason != null) await _crashlytics.setCustomKey("reason", reason);
    if (context != null) {
      for (final entry in context.entries) {
        await _crashlytics.setCustomKey(entry.key, entry.value?.toString() ?? "");
      }
    }

    await _crashlytics.recordError(error, stack, fatal: fatal, reason: reason);
  }

  /// Log breadcrumb
  static void log(String message) {
    _crashlytics.log(message);
  }

  /// Set current user details
  static Future<void> setUser(Map<String, dynamic> userData) async {
    if (!_initialized) return;

    if (userData.containsKey("id")) {
      await _crashlytics.setUserIdentifier(userData["id"].toString());
    }
    for (final entry in userData.entries) {
      await _crashlytics.setCustomKey(entry.key, entry.value?.toString() ?? "");
    }
  }

  /// Clear user info (e.g., on logout)
  static Future<void> clearUser() async {
    await _crashlytics.setUserIdentifier("anonymous");
    await _crashlytics.setCustomKey("role", "guest");
  }

  /// Force crash (for testing)
  static void forceCrash() {
    _crashlytics.crash();
  }

  /// Record API errors with request & response details
  static Future<void> recordApiError({
    required String endpoint,
    required dynamic request,
    required dynamic response,
    dynamic error,
    StackTrace? stack,
    String? reason,
    int? statusCode,
  }) async {
    if (!_initialized) return;

    await _crashlytics.setCustomKey("api_endpoint", endpoint);
    await _crashlytics.setCustomKey("api_request", request?.toString() ?? "");
    await _crashlytics.setCustomKey("api_response", response?.toString() ?? "");
    if (statusCode != null) await _crashlytics.setCustomKey("status_code", statusCode);

    await _crashlytics.recordError(
      error ?? "API Error",
      stack ?? StackTrace.current,
      reason: reason ?? "API Failure",
      fatal: false,
    );
  }
}
