import 'dart:ui';

import 'package:bdt/ui/VolumeSliderDialog.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/AudioScheme.dart';

class PrefDef {
  String key;
  dynamic defaultValue;
  PrefDef(this.key, this.defaultValue);
}
class PreferenceService implements ITranslatePreferences {

  static final PREF_COLOR_SCHEME = PrefDef('pref/common/colorScheme', 0);
  static final PREF_DARK_MODE = PrefDef('pref/common/darkMode', true);
  static final PREF_AUDIO_SCHEME = PrefDef('pref/common/audioScheme', DEFAULT_AUDIO_SCHEME_ID);
  static final PREF_NOTIFY_AT_BREAKS = PrefDef('pref/run/notifyAtBreaks', true);
  static final PREF_VIBRATE_AT_BREAKS = PrefDef('pref/run/vibrateAtBreaks', true);
  static final PREF_SIGNAL_TWICE = PrefDef('pref/run/signalTwice', false);
  static final PREF_BREAK_ORDER_DESCENDING = PrefDef('pref/run/breakOrderDescending', false);
  static final PREF_SIGNAL_VOLUME = PrefDef('pref/run/signalVolume', MAX_VOLUME);
  static final PREF_HIDE_PREDEFINED_PRESETS = PrefDef('pref/presets/hidePredefinedPresets', false);
  static final PREF_USER_PRESETS_ON_TOP = PrefDef('pref/presets/userPresetsOnTop', false);
  static final PREF_CLEAR_STATE_ON_STARTUP = PrefDef('pref/presets/clearStateOnStartup', false);
  static final PREF_CLOCK_MODE_AS_DEFAULT = PrefDef('pref/presets/clockModeAsDefault', false);
  static final PREF_WAKE_LOCK = PrefDef('pref/common/wakeLock', false);
  static final PREF_TIMER_PROGRESS_PRESENTATION = PrefDef('pref/timerProgressPresentation', 0);
  static final PREF_CLOCK_PROGRESS_PRESENTATION = PrefDef('pref/clockProgressPresentation', 0);

  static final DATA_SAVED_BREAK_DOWNS_PREFIX = PrefDef('data/savedBreakDowns_', null);
  static final DATA_PINNED_BREAK_DOWN = PrefDef('data/pinnedBreakDown', null);
  static final DATA_BATTERY_SAVING_RESTRICTIONS_HINT_DISMISSED = PrefDef('data/batteryHintDismissed', false);

  static final STATE_RUN_STATE = PrefDef('state/runState', null);
  static final STATE_RUN_BREAKS_COUNT = PrefDef('state/runBreaksCount', null);
  static final STATE_RUN_PROGRESS = PrefDef('state/runProgress', null);
  static final STATE_RUN_STARTED_AT = PrefDef('state/runStartedAt', null);
  static final STATE_SIGNAL_PROCESSING = PrefDef('state/signalProcessing', null);
  static final STATE_SIGNAL_CANCELLING = PrefDef('state/signalCancelling', null);


  static final PreferenceService _service = PreferenceService._internal();

  var languageSelection;
  int colorSchema = PREF_COLOR_SCHEME.defaultValue;
  int audioSchema = PREF_AUDIO_SCHEME.defaultValue;
  bool userPresetsOnTop = PREF_USER_PRESETS_ON_TOP.defaultValue;
  bool hidePredefinedPresets = PREF_HIDE_PREDEFINED_PRESETS.defaultValue;
  bool darkTheme = true;

  factory PreferenceService() {
    return _service;
  }

  PreferenceService._internal() {}
  
  init() async {
    await refresh();
  }

  refresh() async {
    colorSchema = await getInt(PREF_COLOR_SCHEME) ?? PREF_COLOR_SCHEME.defaultValue;
    darkTheme = await getBool(PREF_DARK_MODE) ?? PREF_DARK_MODE.defaultValue;
    audioSchema = await getInt(PREF_AUDIO_SCHEME) ?? PREF_AUDIO_SCHEME.defaultValue;
    userPresetsOnTop = await getBool(PREF_USER_PRESETS_ON_TOP) ?? PREF_USER_PRESETS_ON_TOP.defaultValue;
    hidePredefinedPresets = await getBool(PREF_HIDE_PREDEFINED_PRESETS) ?? PREF_HIDE_PREDEFINED_PRESETS.defaultValue;
  }

  Future<String?> getString(PrefDef def) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(def.key)??def.defaultValue;
  }

  Future<int?> getInt(PrefDef def) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(def.key)??def.defaultValue;
  }

  Future<bool?> getBool(PrefDef def) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(def.key)??def.defaultValue;
  }

  Future<List<String>> getKeys(String prefix) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getKeys().where((key) => key.startsWith(prefix)).toList();
  }

  Future<bool> setString(PrefDef def, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(def.key, value);
  }

  Future<bool> setInt(PrefDef def, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(def.key, value);
  }

  Future<bool> setBool(PrefDef def, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(def.key, value);
  }

  Future<bool> remove(PrefDef def) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.remove(def.key);
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
      case 1: return const Locale('en');
    }
    return null;
  }

}

