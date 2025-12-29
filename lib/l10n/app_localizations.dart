import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @batterySavingsHint.
  ///
  /// In en, this message translates to:
  /// **'To schedule accurate alarms, this app should be excluded from all battery optimizations. If the app isn\'t working correctly, you should do just that. Open Settings and enable the exception (\'Not Optimized\') for \'{appName}\'.'**
  String batterySavingsHint(Object appName);

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @dontAskAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t ask again'**
  String get dontAskAgain;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @muted.
  ///
  /// In en, this message translates to:
  /// **'muted'**
  String get muted;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'settings'**
  String get settings;

  /// No description provided for @commonSettings.
  ///
  /// In en, this message translates to:
  /// **'Common Settings'**
  String get commonSettings;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @colorScheme.
  ///
  /// In en, this message translates to:
  /// **'Color scheme'**
  String get colorScheme;

  /// No description provided for @selectColorScheme.
  ///
  /// In en, this message translates to:
  /// **'Change a color scheme'**
  String get selectColorScheme;

  /// No description provided for @audioSignals.
  ///
  /// In en, this message translates to:
  /// **'Audio signals'**
  String get audioSignals;

  /// No description provided for @selectAudioScheme.
  ///
  /// In en, this message translates to:
  /// **'Change audio signal scheme'**
  String get selectAudioScheme;

  /// No description provided for @runSettings.
  ///
  /// In en, this message translates to:
  /// **'Run Settings'**
  String get runSettings;

  /// No description provided for @notifyUponReachedBreaks.
  ///
  /// In en, this message translates to:
  /// **'Notifies you when breaks are reached'**
  String get notifyUponReachedBreaks;

  /// No description provided for @notifyUponReachedBreaksDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifies you when a break is reached and a run has started or ended.'**
  String get notifyUponReachedBreaksDescription;

  /// No description provided for @vibrateUponReachedBreaks.
  ///
  /// In en, this message translates to:
  /// **'Vibrates when breaks are reached'**
  String get vibrateUponReachedBreaks;

  /// No description provided for @vibrateUponReachedBreaksDescription.
  ///
  /// In en, this message translates to:
  /// **'Vibrates with a pattern when a break is reached and a run has started or ended.'**
  String get vibrateUponReachedBreaksDescription;

  /// No description provided for @signalTwiceUponReachedBreaks.
  ///
  /// In en, this message translates to:
  /// **'Two signals when breaks are reached'**
  String get signalTwiceUponReachedBreaks;

  /// No description provided for @signalTwiceUponReachedBreaksDescription.
  ///
  /// In en, this message translates to:
  /// **'To ensure no break is missed, each break is signaled twice.'**
  String get signalTwiceUponReachedBreaksDescription;

  /// No description provided for @signalWithoutCounter.
  ///
  /// In en, this message translates to:
  /// **'Signal without counter information'**
  String get signalWithoutCounter;

  /// No description provided for @signalWithoutCounterDescription.
  ///
  /// In en, this message translates to:
  /// **'Don\'t encode the counter in the audio and vibration signal.'**
  String get signalWithoutCounterDescription;

  /// No description provided for @defaultBreakOrder.
  ///
  /// In en, this message translates to:
  /// **'The break order descending by default'**
  String get defaultBreakOrder;

  /// No description provided for @defaultBreakOrderDescription.
  ///
  /// In en, this message translates to:
  /// **'Instead of 1, 2, 3... the order ..., 3, 2, 1 is used.'**
  String get defaultBreakOrderDescription;

  /// No description provided for @showRunSpinner.
  ///
  /// In en, this message translates to:
  /// **'Show run indicator'**
  String get showRunSpinner;

  /// No description provided for @showRunSpinnerDescription.
  ///
  /// In en, this message translates to:
  /// **'Displays a spinning indicator in the timer wheel while the timer is running.'**
  String get showRunSpinnerDescription;

  /// No description provided for @presetSettings.
  ///
  /// In en, this message translates to:
  /// **'Preset Settings'**
  String get presetSettings;

  /// No description provided for @hidePredefinedPresets.
  ///
  /// In en, this message translates to:
  /// **'Hide predefined presets'**
  String get hidePredefinedPresets;

  /// No description provided for @hidePredefinedPresetsDescription.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t need the predefined presets, you can hide them. Only your own custom presets will then be displayed.'**
  String get hidePredefinedPresetsDescription;

  /// No description provided for @customizedPresetsOnTop.
  ///
  /// In en, this message translates to:
  /// **'Show custom presets at the top'**
  String get customizedPresetsOnTop;

  /// No description provided for @customizedPresetsOnTopDescription.
  ///
  /// In en, this message translates to:
  /// **'Custom presets are displayed at the top of the preset list for faster access.'**
  String get customizedPresetsOnTopDescription;

  /// No description provided for @appBehaviourSettings.
  ///
  /// In en, this message translates to:
  /// **'App Behaviour Settings'**
  String get appBehaviourSettings;

  /// No description provided for @activateWakeLock.
  ///
  /// In en, this message translates to:
  /// **'Activate Wake Lock'**
  String get activateWakeLock;

  /// No description provided for @activateWakeLockDescription.
  ///
  /// In en, this message translates to:
  /// **'A wake lock prevents the screen from turning off automatically.'**
  String get activateWakeLockDescription;

  /// No description provided for @startAppFromScratch.
  ///
  /// In en, this message translates to:
  /// **'Launch the app with an empty timer wheel'**
  String get startAppFromScratch;

  /// No description provided for @startAppFromScratchDescription.
  ///
  /// In en, this message translates to:
  /// **'When the app starts, it will launch with an empty timer wheel or your preferred preset. If this option is disabled, the last used state will be restored when the app starts.'**
  String get startAppFromScratchDescription;

  /// No description provided for @clockModeAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Use clock mode as default'**
  String get clockModeAsDefault;

  /// No description provided for @clockModeAsDefaultDescription.
  ///
  /// In en, this message translates to:
  /// **'Set clock mode instead of timer mode as default'**
  String get clockModeAsDefaultDescription;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @batteryOptimizations.
  ///
  /// In en, this message translates to:
  /// **'Battery optimizations'**
  String get batteryOptimizations;

  /// No description provided for @aboutTheApp.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get aboutTheApp;

  /// No description provided for @appShortDescription.
  ///
  /// In en, this message translates to:
  /// **'A timer with intermediate notifications'**
  String get appShortDescription;

  /// No description provided for @visitAppHomePage.
  ///
  /// In en, this message translates to:
  /// **'Visit {url} to view the code, report bugs, and rate!'**
  String visitAppHomePage(Object url);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
