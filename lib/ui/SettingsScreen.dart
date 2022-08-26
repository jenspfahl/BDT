import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../service/PreferenceService.dart';
import 'BDTApp.dart';
import 'dialogs.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final HOMEPAGE = "jepfa.de";
  final HOMEPAGE_SCHEME = "https://";

  final PreferenceService _preferenceService = PreferenceService();

  bool _notifyAtBreaks = true;
  bool _vibrateAtBreaks = true;
  bool _breakOrderDescending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BDT Settings")),
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
          title: Text("Common", style: TextStyle(color: ACCENT_COLOR)),
          tiles: [
            SettingsTile(
              title: Text("Color scheme"),
         //     description: Text(_getLanguageSelectionAsString(_preferenceService.languageSelection)),
              onPressed: (context) {
/*
                showChoiceDialog(context, translate('pages.settings.common.language.dialog.title'),
                    [
                      _getLanguageSelectionAsString(0),
                      _getLanguageSelectionAsString(1),
                      _getLanguageSelectionAsString(2),
                    ],
                    initialSelected: _languageSelection,
                    okPressed: () {
                      Navigator.pop(context);
                      _preferenceService.setInt(PreferenceService.PREF_LANGUAGE_SELECTION, _languageSelection)
                      .then((value) {
                        _preferenceService.languageSelection = _languageSelection;

                        setState(() {
                          _preferenceService.getPreferredLocale().then((locale) {
                            Locale newLocale;
                            if (locale == null) {
                              newLocale = currentLocale(context);
                            }
                            else {
                              newLocale = locale;
                            }
                            debugPrint("change locale to $newLocale");
                            localizationDelegate.changeLocale(newLocale);
                          });
                        });
                      });
                    },
                    cancelPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _loadAllPrefs();
                      });
                    },
                    selectionChanged: (selection) {
                      _languageSelection = selection;
                    }
                );*/
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text("Run Settings", style: TextStyle(color: ACCENT_COLOR)),
          tiles: [
            SettingsTile.switchTile(
              title: Text("Notify on reached breaks"),
              description: Text("Notifies when a break is reached and a run has started or ended."),
              initialValue: _notifyAtBreaks,
              activeSwitchColor: BUTTON_COLOR,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_NOTIFY_AT_BREAKS, value);
                setState(() => _notifyAtBreaks = value);
              },
            ),
            SettingsTile.switchTile(
              title: Text("Vibrate on reached breaks"),
              description: Text("Vibrates with a pattern when a break is reached and a run has started or ended."),
              initialValue: _vibrateAtBreaks,
              activeSwitchColor: BUTTON_COLOR,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_VIBRATE_AT_BREAKS, value);
                setState(() => _vibrateAtBreaks = value);
              },
            ),
            CustomSettingsTile(child: Divider()),
            SettingsTile.switchTile(
              title: Text("Break order descending by default"),
              description: Text("Instead of sequencing 1,2,3 .. it sequences ..,3,2,1."),
              initialValue: _breakOrderDescending,
              activeSwitchColor: BUTTON_COLOR,
              onToggle: (bool value) {
                _preferenceService.setBool(PreferenceService.PREF_BREAK_ORDER_DESCENDING, value);
                setState(() => _breakOrderDescending = value);
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text("Info", style: TextStyle(color: ACCENT_COLOR)),
          tiles: [
            SettingsTile(
              title: Text("About the app"),
              onPressed: (value) {
                showAboutDialog(
                    context: context,
                    applicationVersion: "0.0.1",
                    children: [
                      Text("A timer with several breaks."),
                      Text(""),
                      InkWell(
                          child: Text("Visit $HOMEPAGE for more"),
                          onTap: () {
                            launchUrlString(HOMEPAGE_SCHEME + HOMEPAGE);
                          }),
                      Divider(),
                      Text("© Jens Pfahl 2022", style: TextStyle(fontSize: 12)),
                    ],
                    applicationIcon: Icon(Icons.av_timer));
              },
            ),
          ],
        ),

      ],
    );
  }

  _loadAllPrefs() async {

    final notifyAtBreaks = await _preferenceService.getBool(PreferenceService.PREF_NOTIFY_AT_BREAKS);
    if (notifyAtBreaks != null) {
      _notifyAtBreaks = notifyAtBreaks;
    }
    final vibrateAtBreaks = await _preferenceService.getBool(PreferenceService.PREF_VIBRATE_AT_BREAKS);
    if (vibrateAtBreaks != null) {
      _vibrateAtBreaks = vibrateAtBreaks;
    }
    final breakOrderDescending = await _preferenceService.getBool(PreferenceService.PREF_BREAK_ORDER_DESCENDING);
    if (breakOrderDescending != null) {
      _breakOrderDescending = breakOrderDescending;
    }

  }

}
