import 'package:hive/hive.dart';

class HiveStorageService {
  HiveStorageService._();

  static Future<void> saveString(String key, String value) async {
    final box = await Hive.openBox('appBox');
    await box.put(key, value);
  }

  static Future<String?> getString(String key) async {
    final box = await Hive.openBox('appBox');
    return box.get(key);
  }
}