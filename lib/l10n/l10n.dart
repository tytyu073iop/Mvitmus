import 'dart:convert';
import 'package:flutter/services.dart';

class L10n {
  final Map<String, String> _strings = {};
  String _locale = defaultLocale;

  static const List<String> supportedLocales = ['en', 'ru', 'be'];
  static const String defaultLocale = 'en';

  String get locale => _locale;

  Future<void> load(String locale) async {
    _locale = supportedLocales.contains(locale) ? locale : defaultLocale;
    final data = await rootBundle.loadString('assets/l10n/app_$_locale.arb');
    final map = json.decode(data) as Map<String, dynamic>;
    _strings.clear();
    for (final entry in map.entries) {
      if (entry.value is String) {
        _strings[entry.key] = entry.value as String;
      }
    }
  }

  String translate(String key) {
    return _strings[key] ?? key;
  }
}
