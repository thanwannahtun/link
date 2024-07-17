import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharePreference {
  late SharedPreferences _sharedPreferences;
  static final SharePreference instance = SharePreference._();

  SharePreference._();

  Future<void> _getInstance() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<int?> getInt(String key) async {
    await _getInstance();
    return _sharedPreferences.getInt(key);
  }

  Future<bool?> getBool(String key) async {
    await _getInstance();
    if (_sharedPreferences.getBool(key) == null) return false;
    return _sharedPreferences.getBool(key);
  }

  Future<String?> getString(String key) async {
    await _getInstance();
    return _sharedPreferences.getString(key);
  }

  Future<List<String>?> getStringList(String key) async {
    await _getInstance();
    return _sharedPreferences.getStringList(key);
  }

  Future<bool> setString(String key, String value) async {
    await _getInstance();
    if (value.isEmpty) {
      return false;
    }
    return _sharedPreferences.setString(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    if (value.isNaN) return false;
    await _getInstance();
    return _sharedPreferences.setInt(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    if (value.isEmpty) return false;
    await _getInstance();
    return _sharedPreferences.setStringList(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    await _getInstance();
    return _sharedPreferences.setBool(key, value);
  }

  Future<bool> remove(String key) async {
    await _getInstance();
    return _sharedPreferences.remove(key);
  }
}
