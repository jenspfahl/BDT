// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String batterySavingsHint(Object appName) {
    return 'Um präzise Alarme zu planen, sollte diese App von allen Akkuoptimierungen ausgenommen werden. Funktioniert die App nicht richtig, sollten Sie genau das tun. Öffnen Sie die Einstellungen und aktivieren Sie die Ausnahme (\'Nicht optimiert\') für \'$appName\'.';
  }

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get dontAskAgain => 'Nicht mehr fragen';
}
