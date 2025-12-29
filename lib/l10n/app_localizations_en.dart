// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String batterySavingsHint(Object appName) {
    return 'To schedule accurate alarms, this app should be excluded from all battery optimizations. If the app isn\'t working correctly, you should do just that. Open Settings and enable the exception (\'Not Optimized\') for \'$appName\'.';
  }

  @override
  String get openSettings => 'Open Settings';

  @override
  String get dontAskAgain => 'Don\'t ask again';

  @override
  String get volume => 'Volume';

  @override
  String get mute => 'Mute';

  @override
  String get muted => 'muted';

  @override
  String get hours => 'Hours';

  @override
  String get minutes => 'Minutes';

  @override
  String get settings => 'settings';

  @override
  String get commonSettings => 'Common Settings';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get colorScheme => 'Color scheme';

  @override
  String get selectColorScheme => 'Change a color scheme';

  @override
  String get audioSignals => 'Audio signals';

  @override
  String get selectAudioScheme => 'Change audio signal scheme';

  @override
  String get runSettings => 'Run Settings';

  @override
  String get notifyUponReachedBreaks => 'Notifies you when breaks are reached';

  @override
  String get notifyUponReachedBreaksDescription => 'Notifies you when a break is reached and a run has started or ended.';

  @override
  String get vibrateUponReachedBreaks => 'Vibrates when breaks are reached';

  @override
  String get vibrateUponReachedBreaksDescription => 'Vibrates with a pattern when a break is reached and a run has started or ended.';

  @override
  String get signalTwiceUponReachedBreaks => 'Two signals when breaks are reached';

  @override
  String get signalTwiceUponReachedBreaksDescription => 'To ensure no break is missed, each break is signaled twice.';

  @override
  String get signalWithoutCounter => 'Signal without counter information';

  @override
  String get signalWithoutCounterDescription => 'Don\'t encode the counter in the audio and vibration signal.';

  @override
  String get defaultBreakOrder => 'The break order descending by default';

  @override
  String get defaultBreakOrderDescription => 'Instead of 1, 2, 3... the order ..., 3, 2, 1 is used.';

  @override
  String get showRunSpinner => 'Show run indicator';

  @override
  String get showRunSpinnerDescription => 'Displays a spinning indicator in the timer wheel while the timer is running.';

  @override
  String get presetSettings => 'Preset Settings';

  @override
  String get hidePredefinedPresets => 'Hide predefined presets';

  @override
  String get hidePredefinedPresetsDescription => 'If you don\'t need the predefined presets, you can hide them. Only your own custom presets will then be displayed.';

  @override
  String get customizedPresetsOnTop => 'Show custom presets at the top';

  @override
  String get customizedPresetsOnTopDescription => 'Custom presets are displayed at the top of the preset list for faster access.';

  @override
  String get appBehaviourSettings => 'App Behaviour Settings';

  @override
  String get activateWakeLock => 'Activate Wake Lock';

  @override
  String get activateWakeLockDescription => 'A wake lock prevents the screen from turning off automatically.';

  @override
  String get startAppFromScratch => 'Launch the app with an empty timer wheel';

  @override
  String get startAppFromScratchDescription => 'When the app starts, it will launch with an empty timer wheel or your preferred preset. If this option is disabled, the last used state will be restored when the app starts.';

  @override
  String get clockModeAsDefault => 'Use clock mode as default';

  @override
  String get clockModeAsDefaultDescription => 'Set clock mode instead of timer mode as default';

  @override
  String get info => 'Information';

  @override
  String get batteryOptimizations => 'Battery optimizations';

  @override
  String get aboutTheApp => 'About the app';

  @override
  String get appShortDescription => 'A timer with intermediate notifications';

  @override
  String visitAppHomePage(Object url) {
    return 'Visit $url to view the code, report bugs, and rate!';
  }
}
