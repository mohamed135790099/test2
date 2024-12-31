import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static const String _genderKey = 'genderKey';

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Retrieved token: $token'); // Debug line
    return token;
  }
  // Save the selected gender
  Future<void> saveGender(String gender) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_genderKey, gender);
  }

  // Get the saved gender
  Future<String?> getGender() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_genderKey);
  }
  static Future<void> saveToken(String token) async {
    await sharedPreferences?.setString('token', token);
  }

  static Future saveData({required String key, required dynamic value}) async {
    if (value is String) {
      return await sharedPreferences!.setString(key, value);
    }
    if (value is int) {
      return await sharedPreferences!.setInt(key, value);
    }
    if (value is bool) {
      return await sharedPreferences!.setBool(key, value);
    }

    return await sharedPreferences!.setDouble(key, value);
  }

  static Future<bool> removeData(String key) async {
    return await sharedPreferences!.remove(key);
  }

  static Future<bool> containsKey({required String key}) async {
    return sharedPreferences!.containsKey(key);
  }

  static Future<bool> clearData({required String key}) async {
    return sharedPreferences!.clear();
  }

  static Future<bool> put({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await sharedPreferences!.setString(key, value);
    } else if (value is bool) {
      return await sharedPreferences!.setBool(key, value);
    } else if (value is int) {
      return await sharedPreferences!.setInt(key, value);
    } else if (value is double) {
      return await sharedPreferences!.setDouble(key, value);
    } else {
      throw ArgumentError('Unsupported value type');
    }
  }
}
