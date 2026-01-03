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
  String get close => 'Schließen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get breakName => 'Pause';

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
  String get showArrowsOnTimeValues => 'Zeigt Pfeile an Zeitwerten an';

  @override
  String get showArrowsOnTimeValuesDescription => 'Zeigt während eines Timer-Laufs Pfeile an Werten an, um deren Laufrichtung zu verdeutlichen.';

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
  String visitAppGithubPage(Object url) {
    return 'Besuchen Sie $url, um den Code anzusehen, Fehler zu melden und Sterne zu vergeben!';
  }

  @override
  String visitAppHomePage(Object url) {
    return 'Besuchen Sie $url für mehr Information.';
  }

  @override
  String get help => 'Hilfe';

  @override
  String get appSummary => 'Mit diesem Timer können Sie beliebig viele Zwischen-Benachrichtigungen (\'Pausen\') einstellen, um über den Fortschritt der verstrichenen Zeit informiert zu werden.';

  @override
  String get appExplanation => 'Wählen Sie eine Dauer oder einen Zeitpunkt für den Timer, indem Sie auf die Mitte des Rades klicken. Wählen Sie beliebige Pausen auf dem Timer-Rad aus, indem Sie auf einen Abschnitt klicken. Jede Pause erzeugt ein Signal (akustisch und/oder Vibration) mit folgenden eindeutigen Mustern (zum Abspielen anklicken):';

  @override
  String breakReached(Object breakCount, Object breakNumber) {
    return 'Pause $breakNumber von $breakCount erreicht';
  }

  @override
  String get timerStarted => 'Timer gestartet';

  @override
  String get timerFinished => 'Timer beendet';

  @override
  String get timerFinishedButRepeating => 'Timer beendet, wird aber wiederholt';

  @override
  String afterDuration(Object duration) {
    return 'nach $duration';
  }

  @override
  String afterXRuns(Object runCount) {
    return 'nach $runCount Läufen';
  }

  @override
  String withBreaks(Object breakCount) {
    return 'mit $breakCount Pausen';
  }

  @override
  String get breakPresets => 'Voreinstellungen für Pausen';

  @override
  String breakPresetPinned(Object preset) {
    return 'Voreinstellung \'$preset\' markiert';
  }

  @override
  String breakPresetUnpinned(Object preset) {
    return 'Voreinstellung \'$preset\' nicht mehr markiert';
  }

  @override
  String get savePresetTitle => 'Voreinstellung speichern';

  @override
  String get savePresetMessage => 'Geben Sie einen Namen für diese Voreinstellung ein.';

  @override
  String get savePresetHint => 'Wählen Sie einen Namen';

  @override
  String get savePresetIncludeDuration => 'Dauer speichern';

  @override
  String get savePresetIncludeTime => 'Zeit speichern';

  @override
  String get errorSavePresetNameMissing => 'Name der Voreinstellung fehlt';

  @override
  String get errorSavePresetNameInUse => 'Dieser Name wird bereits verwendet. Wählen Sie einen anderen.';

  @override
  String savePresetDone(Object preset) {
    return '\'$preset\' gespeichert';
  }

  @override
  String get removePresetTitle => 'Gespeicherte Voreinstellung entfernen';

  @override
  String removePresetMessage(Object preset) {
    return 'Möchten Sie \'$preset\' endgültig löschen?';
  }

  @override
  String removePresetDone(Object preset) {
    return '\'$preset\' entfernt';
  }

  @override
  String get breakOrderSwitchedToAscending => 'Pausensortierung aufsteigend';

  @override
  String get breakOrderSwitchedToDescending => 'Pausensortierung absteigend';

  @override
  String get startTimer => 'Start';

  @override
  String get stopTimer => 'Stop';

  @override
  String get swipeToStop => 'Zum Stoppen wischen';

  @override
  String get repeatOnce => 'Einmal wiederholen';

  @override
  String get repeatForever => 'Immer wiederholen';

  @override
  String get noRepeat => 'Keine Wiederholung';

  @override
  String xBreaksPlaced(Object breakCount) {
    return '$breakCount gesetzte Pausen';
  }

  @override
  String xBreaksPlacedRepeatOnce(Object breakCount) {
    return '$breakCount gesetzte Pausen, einmal wiederholen';
  }

  @override
  String xBreaksPlacedRepeatForever(Object breakCount) {
    return '$breakCount gesetzte Pausen, immer wiederholen';
  }

  @override
  String xBreaksLeft(Object breakCount, Object remainingBreaks) {
    return '$remainingBreaks von $breakCount verbleibenden Pausen';
  }

  @override
  String xBreaksLeftRepeatOnce(Object breakCount, Object remainingBreaks, Object runCount) {
    return '$remainingBreaks von $breakCount verbleibenden Pausen, einmal wiederholen (Lauf $runCount von 2)';
  }

  @override
  String xBreaksLeftRepeatForever(Object breakCount, Object remainingBreaks, Object runCount) {
    return '$remainingBreaks von $breakCount verbleibenden Pausen, immer wiederholen (Lauf $runCount)';
  }

  @override
  String get splitBreaks => 'Pausen aufteilen';

  @override
  String splitBreaksDescription(Object duration) {
    return 'Wählen Sie die Anzahl der benötigten Pausen für $duration aus.';
  }

  @override
  String durationBetweenBreaks(Object breakCount, Object duration) {
    return 'Dauer zwischen $breakCount Pausen: $duration';
  }

  @override
  String get errorNoPermissionForNotifications => 'Benachrichtigungen funktionieren nicht, solange diese Berechtigung nicht erteilt wurde.';

  @override
  String get errorDeviceMuted => 'Das Gerät ist stummgeschaltet. Deaktivieren Sie zuerst die Stummschaltung, um die Lautstärke einzustellen.';

  @override
  String errorMaxBreaksReached(Object maxBreakCount) {
    return 'Maximal $maxBreakCount Pausen erlaubt';
  }

  @override
  String get errorNoBreaksToReset => 'Keine Unterbrechungen zum Zurücksetzen';

  @override
  String get errorClockTimeToClose => 'Die Timer-Zeit muss mehr als eine Minute in der Zukunft liegen.';

  @override
  String get errorDurationIsZero => 'Die Dauer darf nicht null sein.';

  @override
  String get errorTimeAlreadyElapsed => 'Die Timer-Zeit ist bereits abgelaufen, setze einen neuen Timer.';
}
