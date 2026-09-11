// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get ok => 'சரி';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get close => 'மூடு';

  @override
  String get reset => 'மீட்டமை';

  @override
  String get breakName => 'இடைவேளை';

  @override
  String batterySavingsHint(Object appName) {
    return 'துல்லியமான அலாரங்களைத் திட்டமிட, இந்த ஆப்ச் அனைத்து பேட்டரி மேம்படுத்தல்களிலிருந்தும் விலக்கப்பட வேண்டும். பயன்பாடு சரியாக வேலை செய்யவில்லை என்றால், நீங்கள் அதைச் செய்ய வேண்டும். அமைப்புகளைத் திறந்து, \'$appName\' க்கான விதிவிலக்கை (\'உகந்ததாக இல்லை\') இயக்கவும்.';
  }

  @override
  String get notExcludeFromBatterySavingsHint => 'Android 12+ introduces a new permission for exact alarms. If exact alarms still do not work, background battery usage must be OPTIMISED again.';

  @override
  String get openSettings => 'அமைப்புகளைத் திறக்கவும்';

  @override
  String get dontAskAgain => 'மீண்டும் கேட்காதே';

  @override
  String get volume => 'தொகுதி';

  @override
  String get mute => 'முடக்கு';

  @override
  String get muted => 'முடக்கப்பட்டது';

  @override
  String get hours => 'மணி';

  @override
  String get minutes => 'நிமிடங்கள்';

  @override
  String get seconds => 'நொடிகள்';

  @override
  String get changeSeconds => 'வினாடிகளை மாற்றவும்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get commonSettings => 'பொதுவான அமைப்புகள்';

  @override
  String get language => 'Language';

  @override
  String get helpToTranslate => 'This is not your language? Help to translate the app!';

  @override
  String get darkTheme => 'இருண்ட கருப்பொருள்';

  @override
  String get useSystemColors => 'மாறும் சிச்டம் நிறங்களைப் பயன்படுத்தவும்';

  @override
  String get colorScheme => 'வண்ணத் திட்டம்';

  @override
  String get selectColorScheme => 'வண்ணத் திட்டத்தை மாற்றவும்';

  @override
  String get audioSignals => 'ஆடியோ சிக்னல்கள்';

  @override
  String get selectAudioScheme => 'ஆடியோ சிக்னல் திட்டத்தை மாற்றவும்';

  @override
  String get runSettings => 'அமைப்புகளை இயக்கவும்';

  @override
  String get notifyUponReachedBreaks => 'இடைவெளிகளை அடையும் போது உங்களுக்குத் தெரிவிக்கும்';

  @override
  String get notifyUponReachedBreaksDescription => 'ஒரு இடைவேளையை அடைந்து, ஒரு ஓட்டம் தொடங்கியது அல்லது முடிந்ததும் உங்களுக்குத் தெரிவிக்கும்.';

  @override
  String get vibrateUponReachedBreaks => 'இடைவெளிகளை அடையும் போது அதிர்கிறது';

  @override
  String get vibrateUponReachedBreaksDescription => 'இடைவேளையை அடைந்து ரன் தொடங்கும் போது அல்லது முடிவடையும் போது ஒரு வடிவத்துடன் அதிர்கிறது.';

  @override
  String get muteVolumeIfDeviceIsMuted => 'Suppress the volume when the device is muted';

  @override
  String get muteVolumeIfDeviceIsMutedDescription => 'When enabled, audio signals are suppressed when the device is muted.';

  @override
  String get signalTwiceUponReachedBreaks => 'இடைவெளிகளை அடையும் போது இரண்டு சமிக்ஞைகள்';

  @override
  String get signalTwiceUponReachedBreaksDescription => 'இடைவெளி தவறவிடாமல் இருக்க, ஒவ்வொரு இடைவெளியும் இரண்டு முறை சமிக்ஞை செய்யப்படுகிறது.';

  @override
  String get signalWithoutCounter => 'எதிர் செய்தி இல்லாத சிக்னல்';

  @override
  String get signalWithoutCounterDescription => 'ஆடியோ மற்றும் அதிர்வு சமிக்ஞையில் கவுண்டரை குறியாக்கம் செய்ய வேண்டாம்.';

  @override
  String get defaultBreakOrder => 'இடைவேளை வரிசை இயல்பாக இறங்குகிறது';

  @override
  String get defaultBreakOrderDescription => '1, 2, 3… வரிசைக்கு பதிலாக …, 3, 2, 1 பயன்படுத்தப்படுகிறது.';

  @override
  String get showRunSpinner => 'ரன் காட்டி காட்டு';

  @override
  String get showRunSpinnerDescription => 'நேரங்குறிகருவி இயங்கும் போது நேரங்குறிகருவி வீலில் சுழலும் குறிகாட்டியைக் காட்டுகிறது.';

  @override
  String get showArrowsOnTimeValues => 'நேர மதிப்புகளில் அம்புகளைக் காட்டுகிறது';

  @override
  String get showArrowsOnTimeValuesDescription => 'ஒரு நேரங்குறிகருவி ஓட்டத்தின் போது மதிப்புகளில் அம்புக்குறிகளை அவற்றின் பயணத்தின் திசையைக் குறிக்கும்.';

  @override
  String get presetSettings => 'முன்னமைக்கப்பட்ட அமைப்புகள்';

  @override
  String get hidePredefinedPresets => 'முன் வரையறுக்கப்பட்ட முன்னமைவுகளை மறை';

  @override
  String get hidePredefinedPresetsDescription => 'முன் வரையறுக்கப்பட்ட முன்னமைவுகள் உங்களுக்குத் தேவையில்லை என்றால், நீங்கள் அவற்றை மறைக்கலாம். உங்கள் சொந்த தனிப்பயன் முன்னமைவுகள் மட்டுமே பின்னர் காட்டப்படும்.';

  @override
  String get customizedPresetsOnTop => 'மேலே தனிப்பயன் முன்னமைவுகளைக் காட்டு';

  @override
  String get customizedPresetsOnTopDescription => 'வேகமான அணுகலுக்காக, தனிப்பயன் முன்னமைவுகள் முன்னமைக்கப்பட்ட பட்டியலின் மேலே காட்டப்படும்.';

  @override
  String get appBehaviourSettings => 'பயன்பாட்டு நடத்தை அமைப்புகள்';

  @override
  String get activateWakeLock => 'வேக் லாக்கை இயக்கவும்';

  @override
  String get activateWakeLockDescription => 'வேக் லாக், திரை தானாகவே அணைக்கப்படுவதைத் தடுக்கிறது.';

  @override
  String get startAppFromScratch => 'வெற்று நேரங்குறிகருவி வீலுடன் பயன்பாட்டைத் தொடங்கவும்';

  @override
  String get startAppFromScratchDescription => 'பயன்பாடு தொடங்கும் போது, அது வெற்று நேரங்குறிகருவி வீல் அல்லது உங்களுக்கு விருப்பமான முன்னமைவுடன் தொடங்கும். இந்த விருப்பம் முடக்கப்பட்டிருந்தால், ஆப்ச் தொடங்கும் போது கடைசியாகப் பயன்படுத்தப்பட்ட நிலை மீட்டமைக்கப்படும்.';

  @override
  String get clockModeAsDefault => 'கடிகார பயன்முறையை இயல்புநிலையாகப் பயன்படுத்தவும்';

  @override
  String get clockModeAsDefaultDescription => 'நேரங்குறிகருவி பயன்முறைக்கு பதிலாக கடிகார பயன்முறையை இயல்புநிலையாக அமைக்கவும்';

  @override
  String get info => 'தகவல்';

  @override
  String get batteryOptimizations => 'பேட்டரி மேம்படுத்தல்கள்';

  @override
  String get aboutTheApp => 'பயன்பாட்டைப் பற்றி';

  @override
  String get appShortDescription => 'இடைநிலை அறிவிப்புகளுடன் கூடிய நேரங்குறிகருவி';

  @override
  String visitAppGithubPage(Object url) {
    return 'குறியீட்டைப் பார்க்கவும், பிழைகளைப் புகாரளிக்கவும், மதிப்பிடவும் $url ஐப் பார்வையிடவும்!';
  }

  @override
  String visitAppHomePage(Object url) {
    return 'மேலும் தகவலுக்கு $url ஐப் பார்வையிடவும்.';
  }

  @override
  String get help => 'உதவி';

  @override
  String get appSummary => 'கடந்த காலத்தின் முன்னேற்றம் குறித்து உங்களுக்குத் தெரிவிக்க, இடைநிலை அறிவிப்புகளை (\'பிரேக்குகள்\') அமைக்க இந்த நேரங்குறிகருவி உங்களை அனுமதிக்கிறது.';

  @override
  String get appExplanation => 'சக்கரத்தின் மையத்தில் சொடுக்கு செய்வதன் மூலம் டைமருக்கான கால அளவு அல்லது நேரத்தைத் தேர்ந்தெடுக்கவும். ஒரு பிரிவைக் சொடுக்கு செய்வதன் மூலம், நேரங்குறிகருவி வீலில் உள்ள இடைவெளிகளைத் தேர்ந்தெடுக்கவும். ஒவ்வொரு இடைவெளியும் பின்வரும் தனித்துவமான வடிவங்களுடன் (விளையாட சொடுக்கு செய்யவும்) ஒரு சமிக்ஞையை (கேட்கும் மற்றும்/அல்லது அதிர்வு) உருவாக்குகிறது:';

  @override
  String breakReached(Object breakCount, Object breakNumber) {
    return '$breakCount இல் $breakNumberஐ எட்டியது';
  }

  @override
  String get timerStarted => 'நேரங்குறிகருவி தொடங்கியது';

  @override
  String get timerFinished => 'நேரங்குறிகருவி முடிந்தது';

  @override
  String get timerFinishedButRepeating => 'நேரங்குறிகருவி முடிந்தது, ஆனால் மீண்டும் வரும்';

  @override
  String afterDuration(Object duration) {
    return '$durationக்குப் பிறகு';
  }

  @override
  String afterXRuns(Object runCount) {
    return '$runCount ரன்களுக்குப் பிறகு';
  }

  @override
  String withBreaks(Object breakCount) {
    return '$breakCount இடைவெளிகளுடன்';
  }

  @override
  String get breakPresets => 'முன்னமைவுகளை உடைக்கவும்';

  @override
  String breakPresetPinned(Object preset) {
    return 'முன்னமைக்கப்பட்ட \'$preset\' பின் செய்யப்பட்டது';
  }

  @override
  String breakPresetUnpinned(Object preset) {
    return 'முன்னமைக்கப்பட்ட \'$preset\' அகற்றப்பட்டது';
  }

  @override
  String get every3rdSlice => 'ஒவ்வொரு 3 வது துண்டு';

  @override
  String get every5thSlice => 'ஒவ்வொரு 5 வது துண்டு';

  @override
  String everyXMinutes(Object count) {
    return 'ஒவ்வொரு $count நிமிடங்களுக்கும்';
  }

  @override
  String get savePresetTitle => 'முன்னமைவைச் சேமிக்கவும்';

  @override
  String get savePresetMessage => 'சேமிக்க உங்கள் முன்னமைவுக்கு ஒரு பெயரை உள்ளிடவும்.';

  @override
  String get savePresetHint => 'ஒரு பெயரை தேர்வு செய்யவும்';

  @override
  String get savePresetIncludeDuration => 'கால அளவைச் சேர்க்கவும்';

  @override
  String get savePresetIncludeTime => 'நேரத்தைச் சேர்க்கவும்';

  @override
  String get errorSavePresetNameMissing => 'முன்னமைக்கப்பட்ட பெயர் இல்லை';

  @override
  String get errorSavePresetNameInUse => 'முன்னமைக்கப்பட்ட பெயர் இன்னும் பயன்படுத்தப்படுகிறது. இன்னொன்றைத் தேர்ந்தெடுங்கள்';

  @override
  String savePresetDone(Object preset) {
    return '\'$preset\' சேமிக்கப்பட்டது';
  }

  @override
  String get removePresetTitle => 'சேமித்த முன்னமைவை அகற்று';

  @override
  String removePresetMessage(Object preset) {
    return '\'$preset\' ஐ நிரந்தரமாக நீக்குவது உறுதியா?';
  }

  @override
  String removePresetDone(Object preset) {
    return '\'$preset\' அகற்றப்பட்டது';
  }

  @override
  String get breakOrderSwitchedToAscending => 'பிரேக் ஆர்டர் ஏறுவரிசைக்கு மாற்றப்பட்டது';

  @override
  String get breakOrderSwitchedToDescending => 'பிரேக் ஆர்டர் இறங்குமுறைக்கு மாற்றப்பட்டது';

  @override
  String get startTimer => 'தொடங்கு';

  @override
  String get stopTimer => 'நிறுத்து';

  @override
  String get swipeToStop => 'நிறுத்த ச்வைப் செய்யவும்';

  @override
  String get repeatOnce => 'ஒரு முறை செய்யவும்';

  @override
  String get repeatForever => 'என்றென்றும் மீண்டும் செய்யவும்';

  @override
  String get noRepeat => 'மீண்டும் இல்லை';

  @override
  String xBreaksPlaced(Object breakCount) {
    return '$breakCount இடைவெளிகள் வைக்கப்பட்டுள்ளன';
  }

  @override
  String xBreaksPlacedRepeatOnce(Object breakCount) {
    return '$breakCount இடைவெளிகள் வைக்கப்பட்டுள்ளன, ஒருமுறை மீண்டும் செய்யவும்';
  }

  @override
  String xBreaksPlacedRepeatForever(Object breakCount) {
    return '$breakCount இடைவெளிகள் வைக்கப்பட்டுள்ளன, எப்போதும் மீண்டும் செய்யவும்';
  }

  @override
  String xBreaksLeft(Object breakCount, Object remainingBreaks) {
    return '$breakCount இல் $remainingBreaks இடைவெளிகள் மீதமுள்ளன';
  }

  @override
  String xBreaksLeftRepeatOnce(Object breakCount, Object remainingBreaks, Object runCount) {
    return '$breakCount இல் $remainingBreaks இடைவெளிகள் மீதமுள்ளன, மீண்டும் ஒரு முறை (ரன் $runCount இல் 2)';
  }

  @override
  String xBreaksLeftRepeatForever(Object breakCount, Object remainingBreaks, Object runCount) {
    return '$breakCount இல் $remainingBreaks இடைவெளிகள் எஞ்சியிருக்கின்றன, நிரந்தரமாக மீண்டும் நிகழும் (ரன் $runCount)';
  }

  @override
  String get splitBreaks => 'பிளவு முறிவுகள்';

  @override
  String splitBreaksDescription(Object duration) {
    return '$durationக்கு தேவையான இடைவெளிகளின் எண்ணிக்கையைத் தேர்ந்தெடுக்கவும்.';
  }

  @override
  String durationBetweenBreaks(Object breakCount, Object duration) {
    return '$breakCount இடைவெளிகளுக்கு இடையேயான கால அளவு: $duration';
  }

  @override
  String get errorNoPermissionForNotifications => 'இந்த இசைவு வழங்கப்படாத வரை அறிவிப்புகள் இயங்காது.';

  @override
  String get errorDeviceMuted => 'சாதனம் முடக்கப்பட்டுள்ளது. ஒலியளவை அமைக்க முதலில் ஒலியை இயக்கவும்.';

  @override
  String errorMaxBreaksReached(Object maxBreakCount) {
    return 'அதிகபட்ச $maxBreakCount இடைவெளிகள் அனுமதிக்கப்படுகின்றன';
  }

  @override
  String get errorNoBreaksToReset => 'மீட்டமைக்க இடைவெளிகள் இல்லை';

  @override
  String get errorClockTimeToClose => 'எதிர்காலத்தில் நேரங்குறிகருவி நேரம் ஒரு நிமிடத்திற்கு மேல் இருக்க வேண்டும்.';

  @override
  String get errorDurationIsZero => 'கால அளவு பூச்சியமாக இருக்க முடியாது.';

  @override
  String get errorTimeAlreadyElapsed => 'நேரங்குறிகருவி நேரம் ஏற்கனவே காலாவதியாகிவிட்டது; புதிய டைமரை அமைக்கவும்.';
}
