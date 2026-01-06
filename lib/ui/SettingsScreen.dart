import 'dart:math';

import 'package:bdt/main.dart';
import 'package:bdt/service/SignalService.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../l10n/app_localizations.dart';
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
  bool _useSystemColors = PreferenceService.PREF_USE_SYSTEM_COLORS.defaultValue;
  int _audioScheme = PreferenceService.PREF_AUDIO_SCHEME.defaultValue;
  bool _showSpinner = PreferenceService.PREF_SHOW_SPINNER.defaultValue;
  bool _showArrows = PreferenceService.PREF_SHOW_ARROWS.defaultValue;
  bool _hidePredefinedPresets = PreferenceService.PREF_HIDE_PREDEFINED_PRESETS.defaultValue;
  bool _userPresetsOnTop = PreferenceService.PREF_USER_PRESETS_ON_TOP.defaultValue;
  bool _enableWakeLock = PreferenceService.PREF_WAKE_LOCK.defaultValue;
  bool _clearStateOnStartup = PreferenceService.PREF_CLEAR_STATE_ON_STARTUP.defaultValue;
  bool _clockModeAsDefault = PreferenceService.PREF_CLOCK_MODE_AS_DEFAULT.defaultValue;


  String _version = 'n/a';

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text('$APP_NAME_SHORT ${l10n.settings}'), elevation: 0),
      body: FutureBuilder(
        future: _loadAllPrefs(),
        builder: (context, AsyncSnapshot snapshot) => _buildSettingsList(),
      ),
    );
  }

  Widget _buildSettingsList()  {

    final l10n = AppLocalizations.of(context)!;

    final visitTextParts = l10n.visitAppGithubPage('<<<URL>>>').split('<<<URL>>>');

    return SettingsList(
      sections: [
        SettingsSection(
          title: Text(l10n.commonSettings, style: TextStyle(color: ColorService().getCurrentScheme().accent)),
          tiles: [
            SettingsTile.switchTile(
              title: Text(l10n.darkTheme),
              initialValue: _darkMode,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_DARK_MODE, value)
                    .then((_) {
                  setState(() {
                    _darkMode = value;
                    _preferenceService.darkTheme = _darkMode;
                    AppBuilder.of(context)?.rebuild();
                  });
                });
              },
            ),
            if (ColorService().isDynamicColorsSupported) SettingsTile.switchTile(
              title: Text(l10n.useSystemColors),
              enabled: ColorService().isDynamicColorsSupported,
              initialValue: _useSystemColors,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_USE_SYSTEM_COLORS, value)
                    .then((_) {
                  setState(() {
                    _useSystemColors = value;
                    _preferenceService.useSystemColors = _useSystemColors;
                    AppBuilder.of(context)?.rebuild();
                  });
                });
              },
            ),
            SettingsTile(
              title: Text(l10n.colorScheme),
              description: Text(_getColorSchemeName(_preferenceService.colorSchema)),
              enabled: !_useSystemColors,
              onPressed: (context) {
                final choices = predefinedColorSchemes
                    .map((e) => ChoiceWidgetRow(
                        e.name,
                        TextStyle(color: ColorService().getScheme(e.id).foreground)))
                    .toList();
                showChoiceDialog(context, l10n.selectColorScheme,
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
              title: Text(l10n.audioSignals),
              description: Text(_getAudioSchemaName(_preferenceService.audioSchema)),
              onPressed: (context) {
                final choices = predefinedAudioSchemes
                    .map((e) => ChoiceWidgetRow(e.name, null))
                    .toList();
                showChoiceDialog(context, l10n.selectAudioScheme,
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
          title: Text(l10n.runSettings, style: TextStyle(color: ColorService().getCurrentScheme().accent)),
          tiles: [
            SettingsTile.switchTile(
              title: Text(l10n.notifyUponReachedBreaks),
              description: Text(l10n.notifyUponReachedBreaksDescription),
              initialValue: _notifyAtBreaks,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_NOTIFY_AT_BREAKS, value);
                setState(() => _notifyAtBreaks = value);
              },
            ),
            SettingsTile.switchTile(
              title: Text(l10n.vibrateUponReachedBreaks),
              description: Text(l10n.vibrateUponReachedBreaksDescription),
              initialValue: _vibrateAtBreaks,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_VIBRATE_AT_BREAKS, value);
                setState(() => _vibrateAtBreaks = value);
              },
            ),
            SettingsTile.switchTile(
              title: Text(l10n.signalTwiceUponReachedBreaks),
              description: Text(l10n.signalTwiceUponReachedBreaksDescription),
              initialValue: _signalTwice,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_SIGNAL_TWICE, value);
                setState(() => _signalTwice = value);
              },
            ),
            SettingsTile.switchTile(
              title: Text(l10n.signalWithoutCounter),
              description: Text(l10n.signalWithoutCounterDescription),
              initialValue: _signalWithoutCounter,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_SIGNAL_WITHOUT_NUMBER, value);
                setState(() => _signalWithoutCounter = value);
              },
            ),
           // const CustomSettingsTile(child: Divider()),
            SettingsTile.switchTile(
              title: Text(l10n.defaultBreakOrder),
              description: Text(l10n.defaultBreakOrderDescription),
              initialValue: _breakOrderDescending,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_BREAK_ORDER_DESCENDING, value);
                setState(() => _breakOrderDescending = value);
              },
            ),
            SettingsTile.switchTile(
              title: Text(l10n.showRunSpinner),
              description: Text(l10n.showRunSpinnerDescription),
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
            SettingsTile.switchTile(
              title: Text(l10n.showArrowsOnTimeValues),
              description: Text(l10n.showArrowsOnTimeValuesDescription),
              initialValue: _showArrows,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) async {
                await _preferenceService.setBool(PreferenceService.PREF_SHOW_ARROWS, value);
                await _preferenceService.refresh();
                setState(() {
                  _showArrows = value;
                });
              },
            ),
          ],
        ),
        SettingsSection(
         title: Text(l10n.presetSettings, style: TextStyle(color: ColorService().getCurrentScheme().accent)),
          tiles: [
            SettingsTile.switchTile(
              title: Text(l10n.hidePredefinedPresets),
              description: Text(l10n.hidePredefinedPresetsDescription),
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
              title: Text(l10n.customizedPresetsOnTop),
              enabled: !_hidePredefinedPresets,
              description: Text(l10n.customizedPresetsOnTopDescription),
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
          title: Text(l10n.appBehaviourSettings, style: TextStyle(color: ColorService().getCurrentScheme().accent)),
          tiles: [
            SettingsTile.switchTile(
              title: Text(l10n.activateWakeLock),
              description: Text(l10n.activateWakeLockDescription),
              initialValue: _enableWakeLock,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_WAKE_LOCK, value);
                setState(() => _enableWakeLock = value);
              },
            ),
            SettingsTile.switchTile(
              title: Text(l10n.startAppFromScratch),
              description: Text(l10n.startAppFromScratchDescription),
              initialValue: _clearStateOnStartup,
              activeSwitchColor: ColorService().getCurrentScheme().button,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_CLEAR_STATE_ON_STARTUP, value);
                setState(() => _clearStateOnStartup = value);
              },
            ),
            SettingsTile.switchTile(
              title: Text(l10n.clockModeAsDefault),
              description: Text(l10n.clockModeAsDefaultDescription),
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
          title: Text(l10n.info, style: TextStyle(color: ColorService().getCurrentScheme().accent)),
          tiles: [
            SettingsTile(
              title: Text(l10n.batteryOptimizations),
              onPressed: (value) {
                showBatterySavingHint(context, _preferenceService);
              }
            ),
            SettingsTile(
              title: Text(l10n.aboutTheApp),
              onPressed: (value) {
                showAboutDialog(
                    context: context,
                    applicationVersion: _version,
                    applicationName: APP_NAME_SHORT,
                    children: [
                      const Text('alias', style: TextStyle(fontSize: 12)),
                      const Text(APP_NAME, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Divider(),
                      Text(l10n.appShortDescription),
                      const Text(''),
                      InkWell(
                          child: Text.rich(
                            TextSpan(
                              text: '${visitTextParts.firstOrNull} ',
                              children: <TextSpan>[
                                TextSpan(text: HOMEPAGE, style: const TextStyle(decoration: TextDecoration.underline)),
                                TextSpan(text: ' ${visitTextParts.lastOrNull}'),
                              ],
                            ),
                          ),
                          onTap: () {
                            launchUrlString(HOMEPAGE_SCHEME + HOMEPAGE + HOMEPAGE_PATH, mode: LaunchMode.externalApplication);
                          }),
                      const Divider(),
                      const Text('© Jens Pfahl 2022-26', style: TextStyle(fontSize: 12)),
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
    final useSystemColors = await _preferenceService.getBool(PreferenceService.PREF_USE_SYSTEM_COLORS);
    if (useSystemColors != null) {
      _useSystemColors = useSystemColors;
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
    final showArrows = await _preferenceService.getBool(PreferenceService.PREF_SHOW_ARROWS);
    if (showArrows != null) {
      _showArrows = showArrows;
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
