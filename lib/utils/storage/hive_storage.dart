import 'package:community_app/res/hive_keys.dart';
import 'package:hive/hive.dart';

class HiveStorageService {
  HiveStorageService._();

  static late Box _box;

  /// Call this once at app start
  static Future<void> init() async {
    _box = await Hive.openBox('appBox');
  }

  /// LANGUAGE CODE
  static Future<void> setLanguageCode(String langCode) async {
    await _box.put(HiveKeys.languageCode, langCode);
  }

  static String? getLanguageCode() {
    return _box.get(HiveKeys.languageCode);
  }

  /// ONBOARDING COMPLETED
  static Future<void> setOnboardingCompleted(bool completed) async {
    await _box.put(HiveKeys.onboardingCompleted, completed);
  }

  static bool getOnboardingCompleted() {
    return _box.get(HiveKeys.onboardingCompleted, defaultValue: false);
  }

  /// Option Selection COMPLETED
  static Future<void> setOptionSelectionCompleted(bool completed) async {
    await _box.put(HiveKeys.optionSelectionCompleted, completed);
  }

  static bool getOptionSelectionCompleted() {
    return _box.get(HiveKeys.optionSelectionCompleted, defaultValue: false);
  }

  /// USER FLOW
  static Future<void> setUserCategory(String flow) async {
    await _box.put(HiveKeys.userCategory, flow);
  }

  static String? getUserCategory() {
    return _box.get(HiveKeys.userCategory);
  }

  //Set Remember Me Data
  static Future<void> setRememberMe(String flow) async {
    await _box.put(HiveKeys.rememberMe, flow);
  }

  static String? getRememberMe() {
    return _box.get(HiveKeys.rememberMe);
  }

  //Set FCM Token
  static Future<void> setFCMToken(String flow) async {
    await _box.put(HiveKeys.fcmToken, flow);
  }

  static String? getFCMToken() {
    return _box.get(HiveKeys.fcmToken);
  }

  //
  static Future<void> setUserData(String flow) async {
    await _box.put(HiveKeys.userData, flow);
  }

  static String? getUserData() {
    return _box.get(HiveKeys.userData);
  }

  static Future<void> setNotification(bool flow) async {
    await _box.put(HiveKeys.notification, flow);
  }

  static bool? getNotification() {
    return _box.get(HiveKeys.notification);
  }

  /// Remove specific key
  static Future<void> remove(String key) async {
    await _box.delete(key);
  }

  /// Clear all
  static Future<void> clear() async {
    await _box.clear();
  }

  static Future<void> clearOnLogout() async {
    // List of keys you want to preserve even after logout
    final List<String> preserveKeys = [
      HiveKeys.rememberMe,
      HiveKeys.onboardingCompleted,
      // Add more keys in future as needed
    ];

    // Temporary storage of values for preserved keys
    final Map<String, dynamic> preservedData = {};

    for (final key in preserveKeys) {
      if (_box.containsKey(key)) {
        preservedData[key] = _box.get(key);
      }
    }

    // Clear all data
    await _box.clear();

    // Restore preserved values
    for (final entry in preservedData.entries) {
      await _box.put(entry.key, entry.value);
    }
  }
}