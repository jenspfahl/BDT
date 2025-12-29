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
    return 'To schedule exact alarms, this app should be exempted from any battery optimizations. Is scheduling not working properly, you should exempt it. Open the settings, and enable exemption (\'not optimized\') for \'$appName\'.';
  }

  @override
  String get openSettings => 'Open Settings';

  @override
  String get dontAskAgain => 'Don\'t ask again';
}
