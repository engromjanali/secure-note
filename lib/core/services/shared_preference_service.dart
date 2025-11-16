import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  SharedPrefService._internal();

  static SharedPrefService? _instance;

  static SharedPrefService get instance {
    _instance ??=
        SharedPrefService._internal(); // Create instance if not exists
    return _instance!; // Return the instance
  }

  SharedPreferences? _prefs;

  SharedPreferences? get prefs {
    return _prefs;
  }

  Future<void> setInt(String key, int value) async {
    final SharedPreferences? prefs = _prefs;
    await prefs?.setInt(key, value);
  }

  Future<SharedPreferences?> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs;
  }

  Future<int?> getInt(String key) async {
    final SharedPreferences? prefs = _prefs;
    return prefs?.getInt(key) ?? 0;
  }

  void setBool(String key, bool value) async {
    final SharedPreferences? prefs = _prefs;
    prefs?.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    final SharedPreferences? prefs = _prefs;
    return prefs?.getBool(key) ?? false;
  }

  Future setString(String key, String value) async {
    final SharedPreferences? prefs = _prefs;
    await prefs?.setString(key, value);
  }

  Future<String> getString(String key) async {
    final SharedPreferences? prefs = _prefs;
    return prefs?.getString(key) ?? "";
  }

  Future<bool> contains(String key) async {
    final SharedPreferences? prefs = _prefs;
    if (prefs?.containsKey(key) ?? false) {
      return false;
    }
    return true;
  }

  void clear() async {
    final SharedPreferences? prefs = _prefs;
    prefs?.clear();
  }

  Future<bool> remove(String key) async {
    final SharedPreferences? prefs = _prefs;
    prefs?.remove(key);
    return true;
  }
}
