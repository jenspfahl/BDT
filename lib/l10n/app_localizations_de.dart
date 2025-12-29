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

  @override
  String get volume => 'Lautstärke';

  @override
  String get mute => 'stummschalten';

  @override
  String get muted => 'stumm';

  @override
  String get hours => 'Stunden';

  @override
  String get minutes => 'Minuten';

  @override
  String get settings => 'Einstellungen';

  @override
  String get commonSettings => 'Allgemeine Einstellungen';

  @override
  String get darkTheme => 'Dunkles Design';

  @override
  String get colorScheme => 'Farbschema';

  @override
  String get selectColorScheme => 'Farbschema ändern';

  @override
  String get audioSignals => 'Audiosignale';

  @override
  String get selectAudioScheme => 'Audiosignal-Schema ändern';

  @override
  String get runSettings => 'Lauf-Einstellungen';

  @override
  String get notifyUponReachedBreaks => 'Benachrichtigt bei erreichten Pausen';

  @override
  String get notifyUponReachedBreaksDescription => 'Benachrichtigt, wenn eine Pause erreicht wird und ein Lauf gestartet oder beendet wurde.';

  @override
  String get vibrateUponReachedBreaks => 'Vibriert bei erreichten Pausen';

  @override
  String get vibrateUponReachedBreaksDescription => 'Vibriert mit einem Muster, wenn eine Pause erreicht wird und ein Lauf gestartet oder beendet wurde.';

  @override
  String get signalTwiceUponReachedBreaks => 'Zweimaliges Signal bei erreichten Pausen';

  @override
  String get signalTwiceUponReachedBreaksDescription => 'Um keine Pause zu verpassen, wird jede Pause zweimal signalisiert.';

  @override
  String get signalWithoutCounter => 'Signal ohne Zählerinformation';

  @override
  String get signalWithoutCounterDescription => 'Der Pausenzähler wird nicht im Audio- und Vibrationssignal kodiert.';

  @override
  String get defaultBreakOrder => 'Die Pausenreihenfolge ist standardmäßig absteigend';

  @override
  String get defaultBreakOrderDescription => 'Anstatt 1, 2, 3 ... wird die Reihenfolge ..., 3, 2, 1 verwendet.';

  @override
  String get showRunSpinner => 'Lauf-Indikator anzeigen';

  @override
  String get showRunSpinnerDescription => 'Zeigt während der Timer läuft einen rotierenden Indikator im Timer-Rad an.';

  @override
  String get presetSettings => 'Voreinstellungen';

  @override
  String get hidePredefinedPresets => 'Vordefinierte Voreinstellungen ausblenden';

  @override
  String get hidePredefinedPresetsDescription => 'Wenn Sie die vordefinierten Voreinstellungen nicht benötigen, können Sie diese ausblenden. Es werden dann nur Ihre eigenen erstellten Voreinstellungen angezeigt.';

  @override
  String get customizedPresetsOnTop => 'Benutzerdefinierte Voreinstellungen oben anzeigen';

  @override
  String get customizedPresetsOnTopDescription => 'Benutzer-Voreinstellungen werden für einen schnelleren Zugriff oben in der Voreinstellungsliste angezeigt.';

  @override
  String get appBehaviourSettings => 'App-Verhaltenseinstellungen';

  @override
  String get activateWakeLock => 'Aktiviert den Wake-Lock';

  @override
  String get activateWakeLockDescription => 'Ein Wake-Lock verhindert, dass sich der Bildschirm automatisch ausschaltet.';

  @override
  String get startAppFromScratch => 'App mit leerem Timer-Rad starten';

  @override
  String get startAppFromScratchDescription => 'Wenn die App startet, wird mit leerem Timer-Rad oder mit der präferierten Voreinstellung gestartet. Wenn diese Option deaktiviert ist, wird der zuletzt verwendete Zustand beim Start der App wiederhergestellt.';

  @override
  String get clockModeAsDefault => 'Uhrzeit-Modus als Standard verwenden';

  @override
  String get clockModeAsDefaultDescription => 'Uhrzeit-Modus anstelle des Timer-Modus als Standard festlegen';

  @override
  String get info => 'Informationen';

  @override
  String get batteryOptimizations => 'Akkuoptimierungen';

  @override
  String get aboutTheApp => 'Über die App';

  @override
  String get appShortDescription => 'Ein Timer mit Zwischenbenachrichtigungen';

  @override
  String visitAppHomePage(Object url) {
    return 'Besuchen Sie $url, um den Code anzusehen, Fehler zu melden und Sterne zu vergeben!';
  }
}
