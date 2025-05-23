import 'dart:math';

import 'package:bdt/main.dart';
import 'package:bdt/service/SignalService.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
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
  bool _signalWithoutCounter = PreferenceService.PREF_SIGNAL_WITHOUT_NUMBER.defaultValue;
  bool _breakOrderDescending = PreferenceService.PREF_BREAK_ORDER_DESCENDING.defaultValue;
  int _colorScheme = PreferenceService.PREF_COLOR_SCHEME.defaultValue;
  bool _darkMode = PreferenceService.PREF_DARK_MODE.defaultValue;
  int _audioScheme = PreferenceService.PREF_AUDIO_SCHEME.defaultValue;
  bool _showSpinner = PreferenceService.PREF_SHOW_SPINNER.defaultValue;
  bool _hidePredefinedPresets = PreferenceService.PREF_HIDE_PREDEFINED_PRESETS.defaultValue;
  bool _userPresetsOnTop = PreferenceService.PREF_USER_PRESETS_ON_TOP.defaultValue;
  bool _enableWakeLock = PreferenceService.PREF_WAKE_LOCK.defaultValue;
  bool _clearStateOnStartup = PreferenceService.PREF_CLEAR_STATE_ON_STARTUP.defaultValue;
  bool _clockModeAsDefault = PreferenceService.PREF_CLOCK_MODE_AS_DEFAULT.defaultValue;


  String _version = 'n/a';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$APP_NAME_SHORT Settings'), elevation: 0),
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
            SettingsTile.switchTile(
              title: const Text('Dark theme'),
              initialValue: _darkMode,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_DARK_MODE, value)
                    .then((_) {
                  setState(() {
                    _darkMode = value;
                    _preferenceService.darkTheme = _darkMode;
                    debugPrint('dartheme=$_darkMode');
                    AppBuilder.of(context)?.rebuild();
                  });
                });
              },
            ),
            SettingsTile(
              title: const Text('Color scheme'),
              description: Text(_getColorSchemeName(_preferenceService.colorSchema)),
              onPressed: (context) {
                final choices = predefinedColorSchemes
                    .map((e) => ChoiceWidgetRow(
                        e.name,
                        TextStyle(color: ColorService().getScheme(e.id).foreground)))
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
              title: const Text('Audio signals'),
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
                      await SignalService.makeSignal(const Duration(milliseconds: 400),
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
              title: const Text('Notify upon reached breaks'),
              description: const Text('Notifies when a break is reached and a run has started or ended.'),
              initialValue: _notifyAtBreaks,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_NOTIFY_AT_BREAKS, value);
                setState(() => _notifyAtBreaks = value);
              },
            ),
            SettingsTile.switchTile(
              title: const Text('Vibrate upon reached breaks'),
              description: const Text('Vibrates with a pattern when a break is reached and a run has started or ended.'),
              initialValue: _vibrateAtBreaks,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_VIBRATE_AT_BREAKS, value);
                setState(() => _vibrateAtBreaks = value);
              },
            ),
            SettingsTile.switchTile(
              title: const Text('Signal twice on reached breaks'),
              description: const Text('To not miss it, signal every break twice.'),
              initialValue: _signalTwice,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_SIGNAL_TWICE, value);
                setState(() => _signalTwice = value);
              },
            ),
            SettingsTile.switchTile(
              title: const Text('Signal without counter'),
              description: const Text('Don''t encode the counter in the audio and vibration signal.'),
              initialValue: _signalWithoutCounter,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_SIGNAL_WITHOUT_NUMBER, value);
                setState(() => _signalWithoutCounter = value);
              },
            ),
           // const CustomSettingsTile(child: Divider()),
            SettingsTile.switchTile(
              title: const Text('Break order descending by default'),
              description: const Text('Instead of sequencing 1,2,3 .. it sequences ..,3,2,1.'),
              initialValue: _breakOrderDescending,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_BREAK_ORDER_DESCENDING, value);
                setState(() => _breakOrderDescending = value);
              },
            ),
            SettingsTile.switchTile(
              title: const Text('Show run spinner'),
              description: const Text('Shows a rotating spinner inside the wheel during running.'),
              initialValue: _showSpinner,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) async {
                await _preferenceService.setBool(PreferenceService.PREF_SHOW_SPINNER, value);
                await _preferenceService.refresh();
                setState(() {
                  _showSpinner = value;
                });
              },
            ),
          ],
        ),
        SettingsSection(
         title: Text('Preset Settings', style: TextStyle(color: ColorService().getCurrentScheme().accent)),
          tiles: [
            SettingsTile.switchTile(
              title: const Text('Hide predefined presets'),
              description: const Text('If you don''t need it you can hide the predefined presets from the preset list. Only your own presets will be shown then.'),
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
              title: const Text('User presets on top'),
              enabled: !_hidePredefinedPresets,
              description: const Text('Show user presets on top of the preset list for faster access.'),
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
              title: const Text('Enable wake lock'),
              description: const Text('Enable the screen wakelock, which prevents the screen from turning off automatically.'),
              initialValue: _enableWakeLock,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_WAKE_LOCK, value);
                setState(() => _enableWakeLock = value);
              },
            ),
            SettingsTile.switchTile(
              title: const Text('Start from scratch after app startup'),
              description: const Text('Start with empty wheel and no selected preset if nothing is pinned. If disabled, the recent state is restored upon app startup.'),
              initialValue: _clearStateOnStartup,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_CLEAR_STATE_ON_STARTUP, value);
                setState(() => _clearStateOnStartup = value);
              },
            ),
            SettingsTile.switchTile(
              title: const Text('Use Clock Mode as default'),
              description: const Text('Set Clock Mode as default instead of Timer Mode'),
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
              title: const Text('Battery optimizations'),
              onPressed: (value) {
                showBatterySavingHint(context, _preferenceService);
              }
            ),
            SettingsTile(
              title: const Text('About the app'),
              onPressed: (value) {
                showAboutDialog(
                    context: context,
                    applicationVersion: _version,
                    applicationName: APP_NAME_SHORT,
                    children: [
                      const Text('alias', style: TextStyle(fontSize: 12)),
                      const Text(APP_NAME, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Divider(),
                      const Text('A timer with in-between notifications'),
                      const Text(''),
                      InkWell(
                          child: Text.rich(
                            TextSpan(
                              text: 'Visit ',
                              children: <TextSpan>[
                                TextSpan(text: HOMEPAGE, style: const TextStyle(decoration: TextDecoration.underline)),
                                const TextSpan(text: ' to view the code, report bugs and give stars!'),
                              ],
                            ),
                          ),
                          onTap: () {
                            launchUrlString(HOMEPAGE_SCHEME + HOMEPAGE + HOMEPAGE_PATH, mode: LaunchMode.externalApplication);
                          }),
                      const Divider(),
                      const Text('© Jens Pfahl 2025', style: TextStyle(fontSize: 12)),
                    ],
                    applicationIcon: const SizedBox(width: 64, height: 64,
                        child: ImageIcon(AssetImage('assets/launcher_bdt_adaptive_fore.png'))));
              },
            ),
            const CustomSettingsTile(child: SizedBox(height: 36)),
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
    final signalWithoutCounter = await _preferenceService.getBool(PreferenceService.PREF_SIGNAL_WITHOUT_NUMBER);
    if (signalWithoutCounter != null) {
      _signalWithoutCounter = signalWithoutCounter;
    }
    final breakOrderDescending = await _preferenceService.getBool(PreferenceService.PREF_BREAK_ORDER_DESCENDING);
    if (breakOrderDescending != null) {
      _breakOrderDescending = breakOrderDescending;
    }
    final colorScheme = await _preferenceService.getInt(PreferenceService.PREF_COLOR_SCHEME);
    if (colorScheme != null) {
      _colorScheme = colorScheme;
    }
    final darkMode = await _preferenceService.getBool(PreferenceService.PREF_DARK_MODE);
    if (darkMode != null) {
      _darkMode = darkMode;
    }
    final audioScheme = await _preferenceService.getInt(PreferenceService.PREF_AUDIO_SCHEME);
    if (audioScheme != null) {
      _audioScheme = audioScheme;
    }
    final hidePredefinedPresets = await _preferenceService.getBool(PreferenceService.PREF_HIDE_PREDEFINED_PRESETS);
    if (hidePredefinedPresets != null) {
      _hidePredefinedPresets = hidePredefinedPresets;
    }
    final showSpinner = await _preferenceService.getBool(PreferenceService.PREF_SHOW_SPINNER);
    if (showSpinner != null) {
      _showSpinner = showSpinner;
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
