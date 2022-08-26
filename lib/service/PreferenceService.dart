import 'dart:ui';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService implements ITranslatePreferences {

  static final PREF_COLOR_SCHEME = "common/colorScheme";
  static final PREF_NOTIFY_AT_BREAKS = "run/notifyAtBreaks";
  static final PREF_VIBRATE_AT_BREAKS = "run/vibrateAtBreaks";
  static final PREF_BREAK_ORDER_DESCENDING = "run/breakOrderDescending";
  

  static final PreferenceService _service = PreferenceService._internal();

  var languageSelection;
  int? _colorSchemaSelection = null;

  factory PreferenceService() {
    return _service;
  }

  PreferenceService._internal() {}

  int get colorSchema => _colorSchemaSelection??0;


  init() async {
    await refresh();
  }

  refresh() async {
    _colorSchemaSelection = await getInt(PREF_COLOR_SCHEME);
  }

  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

  Future<int?> getInt(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key);
  }

  Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key);
  }

  Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(key, value);
  }

  Future<bool> remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove(key);
  }


  reload() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    await refresh();
  }


  @override
  Future<Locale?> getPreferredLocale() async {
    final languageSelection = null;//await getInt(PREF_LANGUAGE_SELECTION);

    this.languageSelection = languageSelection??0;

    if (languageSelection != null) {
      final locale = _getLocaleFromSelection(languageSelection);

      if (locale != null) {
        return Future.value(locale);
      }
    }
    return Future.value(null);
  }

  @override
  Future savePreferredLocale(Locale locale) async {
    // not needed, saved by SettingsScreen.dart
  }

  Locale? _getLocaleFromSelection(int languageSelection) {
    switch (languageSelection) {
      case 1: return Locale('en');
      case 2: return Locale('de');
    }
    return null;
  }

}

