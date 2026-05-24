import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const String _localeKey = 'locale';
  static const String _lastDistrictKey = 'last_district';

  Future<String> getLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_localeKey) ?? 'ru';
    } catch (e) {
      debugPrint('Error reading locale: $e');
      return 'ru';
    }
  }

  Future<void> setLocale(String locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  Future<int?> getLastDistrictId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_lastDistrictKey);
    } catch (e) {
      debugPrint('Error reading last district: $e');
      return null;
    }
  }

  Future<void> setLastDistrictId(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastDistrictKey, id);
    } catch (e) {
      debugPrint('Error saving last district: $e');
    }
  }
}
