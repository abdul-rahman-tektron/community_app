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

  static bool isOnboardingCompleted() {
    return _box.get(HiveKeys.onboardingCompleted, defaultValue: false);
  }

  /// USER FLOW
  static Future<void> setUserCategory(String flow) async {
    await _box.put(HiveKeys.userCategory, flow);
  }

  static String? getUserCategory() {
    return _box.get(HiveKeys.userCategory);
  }

  //
  static Future<void> setUserData(String flow) async {
    await _box.put(HiveKeys.userData, flow);
  }

  static String? getUserData() {
    return _box.get(HiveKeys.userData);
  }

  /// Remove specific key
  static Future<void> remove(String key) async {
    await _box.delete(key);
  }

  /// Clear all
  static Future<void> clear() async {
    await _box.clear();
  }
}