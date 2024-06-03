// import 'package:shared_preferences/shared_preferences.dart';
//
// class CacheHelper {
//   static SharedPreferences sharedPreferences;
//
//   static init() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//   }
//
//   static Future<bool> putBoolean({
//     required String key,
//     required bool value,
//   }) async {
//     return await sharedPreferences.setBool(key, value);
//   }
//
//   static dynamic getData({
//     required String key,
//   }) {
//     return sharedPreferences.get(key);
//   }
//
//   static Future<bool> saveData({
//     required String key,
//     required dynamic value,
//   }) async {
//     if (value is String) return await sharedPreferences.setString(key, value);
//     if (value is int) return await sharedPreferences.setInt(key, value);
//     if (value is bool) return await sharedPreferences.setBool(key, value);
//
//     return await sharedPreferences.setDouble(key, value);
//   }
//
//   static Future<bool> removeData({
//     required String key,
//   }) async {
//     return await sharedPreferences.remove(key);
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async {
    await _ensureInitialized();
    return await prefs!.setBool(key, value);
  }

  static Future<dynamic> getData({
    required String key,
  }) {
    _ensureInitializedSync();
    return Future.value(prefs!.get(key));
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    await _ensureInitialized();

    if (value is String) return await prefs!.setString(key, value);
    if (value is int) return await prefs!.setInt(key, value);
    if (value is bool) return await prefs!.setBool(key, value);
    if (value is double) return await prefs!.setDouble(key, value);

    throw Exception("Invalid value type");
  }

  static Future<bool> removeData({
    required String key,
  }) async {
    await _ensureInitialized();
    return await prefs!.remove(key);
  }

  static Future<void> _ensureInitialized() async {
    if (prefs == null) {
      await init();
    }
  }

  static void _ensureInitializedSync() {
    if (prefs == null) {
      throw Exception("SharedPreferences not initialized");
    }
  }
}
