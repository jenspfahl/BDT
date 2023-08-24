import 'dart:math';

import 'package:bdt/main.dart';
import 'package:bdt/service/SignalService.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/AudioScheme.dart';
import '../model/ColorScheme.dart';
import '../service/AudioService.dart';
import '../service/ColorService.dart';
import '../service/PreferenceService.dart';
import '../util/prefs.dart';
import 'BDTApp.dart';
import 'ChoiceWidget.dart';
import 'dialogs.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final HOMEPAGE = 'github.com';
  final HOMEPAGE_SCHEME = 'https://';
  final HOMEPAGE_PATH = '/jenspfahl/BDT';

  final PreferenceService _preferenceService = PreferenceService();

  bool _notifyAtBreaks = PreferenceService.PREF_NOTIFY_AT_BREAKS.defaultValue;
  bool _vibrateAtBreaks = PreferenceService.PREF_VIBRATE_AT_BREAKS.defaultValue;
  bool _signalTwice = PreferenceService.PREF_SIGNAL_TWICE.defaultValue;
  bool _breakOrderDescending = PreferenceService.PREF_BREAK_ORDER_DESCENDING.defaultValue;
  int _colorScheme = PreferenceService.PREF_COLOR_SCHEME.defaultValue;
  int _audioScheme = PreferenceService.PREF_AUDIO_SCHEME.defaultValue;
  bool _hidePredefinedPresets = PreferenceService.PREF_HIDE_PREDEFINED_PRESETS.defaultValue;
  bool _userPresetsOnTop = PreferenceService.PREF_USER_PRESETS_ON_TOP.defaultValue;
  bool _enableWakeLock = PreferenceService.PREF_WAKE_LOCK.defaultValue;
  bool _clearStateOnStartup = PreferenceService.PREF_CLEAR_STATE_ON_STARTUP.defaultValue;
  bool _clockModeAsDefault = PreferenceService.PREF_CLOCK_MODE_AS_DEFAULT.defaultValue;


  String _version = 'n/a';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$APP_NAME_SHORT Settings')),
      body: FutureBuilder(
        future: _loadAllPrefs(),
        builder: (context, AsyncSnapshot snapshot) => _buildSettingsList(),
      ),
    );
  }

  Widget _buildSettingsList()  {

    return SettingsList(
      sections: [
        SettingsSection(
          title: Text('Common', style: TextStyle(color: ColorService().getCurrentScheme().accent)),
          tiles: [
            SettingsTile(
              title: Text('Color scheme'),
              description: Text(_getColorSchemeName(_preferenceService.colorSchema)),
              onPressed: (context) {
                final choices = predefinedColorSchemes
                    .map((e) => ChoiceWidgetRow(
                        e.name,
                        TextStyle(color:  e.foreground)))
                    .toList();
                showChoiceDialog(context, 'Select a color scheme',
                    choices,
                    initialSelected: _colorScheme,
                    okPressed: () {
                      Navigator.pop(context);
                      _preferenceService.setInt(PreferenceService.PREF_COLOR_SCHEME, _colorScheme)
                      .then((value) async {
                        await _preferenceService.refresh();
                        setState(() {
                          _colorScheme = _preferenceService.colorSchema;
                          prefsUpdatedNotifier.add(_colorScheme);
                        });
                      });
                    },
                    cancelPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _colorScheme = _preferenceService.colorSchema;
                      });
                    },
                    selectionChanged: (selection) {
                      _colorScheme = selection;
                    }
                );
              },
            ),
            SettingsTile(
              title: Text('Audio signals'),
              description: Text(_getAudioSchemaName(_preferenceService.audioSchema)),
              onPressed: (context) {
                final choices = predefinedAudioSchemes
                    .map((e) => ChoiceWidgetRow(e.name, null))
                    .toList();
                showChoiceDialog(context, 'Select an audio scheme',
                    choices,
                    initialSelected: _audioScheme,
                    okPressed: () {
                      Navigator.pop(context);
                      _preferenceService.setInt(PreferenceService.PREF_AUDIO_SCHEME, _audioScheme)
                          .then((value) async {
                        await _preferenceService.refresh();
                        setState(() {
                          _audioScheme = _preferenceService.audioSchema;
                        });
                      });
                    },
                    cancelPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _audioScheme = _preferenceService.audioSchema;
                      });
                    },
                    selectionChanged: (selection) async {
                      final origVol = await getVolume(_preferenceService);
                      final newVol = max(20, origVol); // not too silent
                      _audioScheme = selection;
                      await SignalService.setSignalVolume(newVol);
                      await SignalService.makeSignal(Duration(milliseconds: 200),
                          audioSchemeId: selection,
                          noVibration: true
                      );
                      await SignalService.setSignalVolume(origVol);
                    }
                );
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text('Run Settings', style: TextStyle(color: ColorService().getCurrentScheme().accent)),
          tiles: [
            SettingsTile.switchTile(
              title: Text('Notify upon reached breaks'),
              description: Text('Notifies when a break is reached and a run has started or ended.'),
              initialValue: _notifyAtBreaks,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_NOTIFY_AT_BREAKS, value);
                setState(() => _notifyAtBreaks = value);
              },
            ),
            SettingsTile.switchTile(
              title: Text('Vibrate upon reached breaks'),
              description: Text('Vibrates with a pattern when a break is reached and a run has started or ended.'),
              initialValue: _vibrateAtBreaks,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_VIBRATE_AT_BREAKS, value);
                setState(() => _vibrateAtBreaks = value);
              },
            ),
            SettingsTile.switchTile(
              title: Text('Signal twice on reached breaks'),
              description: Text('To not miss it, signal every break twice.'),
              initialValue: _signalTwice,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_SIGNAL_TWICE, value);
                setState(() => _signalTwice = value);
              },
            ),
            CustomSettingsTile(child: Divider()),
            SettingsTile.switchTile(
              title: Text('Break order descending by default'),
              description: Text('Instead of sequencing 1,2,3 .. it sequences ..,3,2,1.'),
              initialValue: _breakOrderDescending,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_BREAK_ORDER_DESCENDING, value);
                setState(() => _breakOrderDescending = value);
              },
            ),
          ],
        ),
        SettingsSection(
         title: Text('Preset Settings', style: TextStyle(color: ColorService().getCurrentScheme().accent)),
          tiles: [
            SettingsTile.switchTile(
              title: Text('Hide predefined presets'),
              description: Text('If you don''t need it you can hide the predefined presets from the preset list. Only your own presets will be shown then.'),
              initialValue: _hidePredefinedPresets,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) async {
                await _preferenceService.setBool(PreferenceService.PREF_HIDE_PREDEFINED_PRESETS, value);
                await _preferenceService.refresh();
                setState(() {
                  _hidePredefinedPresets = value;
                });
              },
            ),
            SettingsTile.switchTile(
              title: Text('User presets on top'),
              enabled: !_hidePredefinedPresets,
              description: Text('Show user presets on top of the preset list for faster access.'),
              initialValue: _userPresetsOnTop,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) async {
                await _preferenceService.setBool(PreferenceService.PREF_USER_PRESETS_ON_TOP, value);
                await _preferenceService.refresh();
                setState(() {
                  _userPresetsOnTop = value;
                });
              },
            ),
        ]),
        SettingsSection(
          title: Text('App Behaviour', style: TextStyle(color: ColorService().getCurrentScheme().accent)),
          tiles: [
            SettingsTile.switchTile(
              title: Text('Enable wake lock'),
              description: Text('Enable the screen wakelock, which prevents the screen from turning off automatically.'),
              initialValue: _enableWakeLock,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_WAKE_LOCK, value);
                setState(() => _enableWakeLock = value);
              },
            ),
            SettingsTile.switchTile(
              title: Text('Start from scratch after app startup'),
              description: Text('Start with empty wheel and no selected preset if nothing is pinned. If disabled, the recent state is restored upon app startup.'),
              initialValue: _clearStateOnStartup,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_CLEAR_STATE_ON_STARTUP, value);
                setState(() => _clearStateOnStartup = value);
              },
            ),
            SettingsTile.switchTile(
              title: Text('Use Clock Mode as default'),
              description: Text('Set Clock Mode as default instead of Timer Mode'),
              initialValue: _clockModeAsDefault,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_CLOCK_MODE_AS_DEFAULT, value);
                setState(() => _clockModeAsDefault = value);
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text('Info', style: TextStyle(color: ColorService().getCurrentScheme().accent)),
          tiles: [
            SettingsTile(
              title: Text('Battery optimizations'),
              onPressed: (value) {
                showBatterySavingHint(context, _preferenceService);
              }
            ),
            SettingsTile(
              title: Text('About the app'),
              onPressed: (value) {
                showAboutDialog(
                    context: context,
                    applicationVersion: _version,
                    applicationName: APP_NAME_SHORT,
                    children: [
                      Text('alias', style: TextStyle(fontSize: 12)),
                      Text(APP_NAME, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Divider(),
                      Text('A timer with in-between notifications'),
                      Text(''),
                      InkWell(
                          child: Text.rich(
                            TextSpan(
                              text: 'Visit ',
                              children: <TextSpan>[
                                TextSpan(text: HOMEPAGE, style: TextStyle(decoration: TextDecoration.underline)),
                                TextSpan(text: ' to view the code, report bugs and give stars!'),
                              ],
                            ),
                          ),
                          onTap: () {
                            launchUrlString(HOMEPAGE_SCHEME + HOMEPAGE + HOMEPAGE_PATH, mode: LaunchMode.externalApplication);
                          }),
                      Divider(),
                      Text('© Jens Pfahl 2023 (Play Store variant)', style: TextStyle(fontSize: 12)),
                    ],
                    applicationIcon: SizedBox(width: 64, height: 64,
                        child: ImageIcon(AssetImage('assets/launcher_bdt_adaptive_fore.png'))));
              },
            ),
          ],
        ),

      ],
    );
  }

  _loadAllPrefs() async {

    final packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;

    final notifyAtBreaks = await _preferenceService.getBool(PreferenceService.PREF_NOTIFY_AT_BREAKS);
    if (notifyAtBreaks != null) {
      _notifyAtBreaks = notifyAtBreaks;
    }
    final vibrateAtBreaks = await _preferenceService.getBool(PreferenceService.PREF_VIBRATE_AT_BREAKS);
    if (vibrateAtBreaks != null) {
      _vibrateAtBreaks = vibrateAtBreaks;
    }
    final signalTwice = await _preferenceService.getBool(PreferenceService.PREF_SIGNAL_TWICE);
    if (signalTwice != null) {
      _signalTwice = signalTwice;
    }
    final breakOrderDescending = await _preferenceService.getBool(PreferenceService.PREF_BREAK_ORDER_DESCENDING);
    if (breakOrderDescending != null) {
      _breakOrderDescending = breakOrderDescending;
    }
    final colorScheme = await _preferenceService.getInt(PreferenceService.PREF_COLOR_SCHEME);
    if (colorScheme != null) {
      _colorScheme = colorScheme;
    } 
    final audioScheme = await _preferenceService.getInt(PreferenceService.PREF_AUDIO_SCHEME);
    if (audioScheme != null) {
      _audioScheme = audioScheme;
    }
    final hidePredefinedPresets = await _preferenceService.getBool(PreferenceService.PREF_HIDE_PREDEFINED_PRESETS);
    if (hidePredefinedPresets != null) {
      _hidePredefinedPresets = hidePredefinedPresets;
    }
    final userPresetsOnTop = await _preferenceService.getBool(PreferenceService.PREF_USER_PRESETS_ON_TOP);
    if (userPresetsOnTop != null) {
      _userPresetsOnTop = userPresetsOnTop;
    }
    final enableWakeLock = await _preferenceService.getBool(PreferenceService.PREF_WAKE_LOCK);
    if (enableWakeLock != null) {
      _enableWakeLock = enableWakeLock;
    }
    final clearStateOnStartup = await _preferenceService.getBool(PreferenceService.PREF_CLEAR_STATE_ON_STARTUP);
    if (clearStateOnStartup != null) {
      _clearStateOnStartup = clearStateOnStartup;
    }
    final clockModeAsDefault = await _preferenceService.getBool(PreferenceService.PREF_CLOCK_MODE_AS_DEFAULT);
    if (clockModeAsDefault != null) {
      _clockModeAsDefault = clockModeAsDefault;
    }
  }

  String _getColorSchemeName(int colorSchema) {
    return ColorService().getScheme(colorSchema).name;
  }

  String _getAudioSchemaName(int audioSchema) {
    return AudioService().getScheme(audioSchema).name;
  }

}
