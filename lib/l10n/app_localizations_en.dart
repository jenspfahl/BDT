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
  String get close => 'Close';

  @override
  String get reset => 'Reset';

  @override
  String get breakName => 'break';

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
  String visitAppGithubPage(Object url) {
    return 'Visit $url to view the code, report bugs, and rate!';
  }

  @override
  String visitAppHomePage(Object url) {
    return 'Visit $url for more information.';
  }

  @override
  String get help => 'Help';

  @override
  String get appSummary => 'This timer lets you set any number of intermediate notifications (\'breaks\') to keep you informed about the progress of the elapsed time.';

  @override
  String get appExplanation => 'Select a duration or time for the timer by clicking the center of the wheel. Select any number of breaks on the timer wheel by clicking a segment. Each break generates a signal (audible and/or vibration) with the following unique patterns (click to play):';

  @override
  String breakReached(Object breakCount, Object breakNumber) {
    return 'Break $breakNumber of $breakCount reached';
  }

  @override
  String get timerStarted => 'Timer started';

  @override
  String get timerFinished => 'Timer finished';

  @override
  String get timerFinishedButRepeating => 'Timer finished, but will repeat';

  @override
  String afterDuration(Object duration) {
    return 'after $duration';
  }

  @override
  String afterXRuns(Object runCount) {
    return 'after $runCount runs';
  }

  @override
  String withBreaks(Object breakCount) {
    return 'with $breakCount breaks';
  }

  @override
  String get breakPresets => 'Break presets';

  @override
  String breakPresetPinned(Object preset) {
    return 'Preset \'$preset\' pinned';
  }

  @override
  String breakPresetUnpinned(Object preset) {
    return 'Preset \'$preset\' unpinned';
  }

  @override
  String get savePresetTitle => 'Save preset';

  @override
  String get savePresetMessage => 'Enter a name for your preset to save.';

  @override
  String get savePresetHint => 'choose a name';

  @override
  String get savePresetIncludeDuration => 'Include duration';

  @override
  String get savePresetIncludeTime => 'Include time';

  @override
  String get errorSavePresetNameMissing => 'Preset name missing';

  @override
  String get errorSavePresetNameInUse => 'Preset name still used. Choose another one';

  @override
  String savePresetDone(Object preset) {
    return '\'$preset\' saved';
  }

  @override
  String get removePresetTitle => 'Remove saved preset';

  @override
  String removePresetMessage(Object preset) {
    return 'Are you sure to delete \'$preset\' permanently?';
  }

  @override
  String removePresetDone(Object preset) {
    return '\'$preset\' removed';
  }

  @override
  String get breakOrderSwitchedToAscending => 'Break order changed to ascending';

  @override
  String get breakOrderSwitchedToDescending => 'Break order changed to descending';

  @override
  String get startTimer => 'Start';

  @override
  String get stopTimer => 'Stop';

  @override
  String get swipeToStop => 'Swipe to Stop';

  @override
  String get repeatOnce => 'Repeat once';

  @override
  String get repeatForever => 'Repeat forever';

  @override
  String get noRepeat => 'No repeat';

  @override
  String xBreaksPlaced(Object breakCount) {
    return '$breakCount breaks placed';
  }

  @override
  String xBreaksPlacedRepeatOnce(Object breakCount) {
    return '$breakCount breaks placed, repeat once';
  }

  @override
  String xBreaksPlacedRepeatForever(Object breakCount) {
    return '$breakCount breaks placed, repeat forever';
  }

  @override
  String xBreaksLeft(Object breakCount, Object remainingBreaks) {
    return '$remainingBreaks of $breakCount breaks left';
  }

  @override
  String xBreaksLeftRepeatOnce(Object breakCount, Object remainingBreaks, Object runCount) {
    return '$remainingBreaks of $breakCount breaks left, repeating once (run $runCount of 2)';
  }

  @override
  String xBreaksLeftRepeatForever(Object breakCount, Object remainingBreaks, Object runCount) {
    return '$remainingBreaks of $breakCount breaks left, repeating forever (run $runCount)';
  }

  @override
  String get errorNoPermissionForNotifications => 'Notifications won\'t work as long as this permission is not granted.';

  @override
  String get errorDeviceMuted => 'Device is muted. Unmute first to set volume.';

  @override
  String errorMaxBreaksReached(Object maxBreakCount) {
    return 'Maximum $maxBreakCount breaks allowed';
  }

  @override
  String get errorNoBreaksToReset => 'No breaks to reset';

  @override
  String get errorClockTimeToClose => 'The timer-time must be more than one minute in the future.';

  @override
  String get errorDurationIsZero => 'The duration cannot be zero.';

  @override
  String get errorTimeAlreadyElapsed => 'The timer-time has already expired; set a new timer.';
}
