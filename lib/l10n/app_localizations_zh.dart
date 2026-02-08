// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get ok => '确定';

  @override
  String get cancel => '取消';

  @override
  String get close => '关闭';

  @override
  String get reset => '重置';

  @override
  String get breakName => '休息';

  @override
  String batterySavingsHint(Object appName) {
    return '为确保闹钟准时提醒，此应用应排除在所有电池优化之外。如果应用无法正常工作，请按此操作：打开“设置”并为“$appName”启用例外（“未优化”）。';
  }

  @override
  String get openSettings => '打开设置';

  @override
  String get dontAskAgain => '不再询问';

  @override
  String get volume => '音量';

  @override
  String get mute => '静音';

  @override
  String get muted => '已静音';

  @override
  String get hours => '小时';

  @override
  String get minutes => '分钟';

  @override
  String get seconds => '秒';

  @override
  String get changeSeconds => '更改秒数';

  @override
  String get settings => '设置';

  @override
  String get commonSettings => '通用设置';

  @override
  String get darkTheme => '深色主题';

  @override
  String get useSystemColors => '使用动态系统配色';

  @override
  String get colorScheme => '配色方案';

  @override
  String get selectColorScheme => '更改配色方案';

  @override
  String get audioSignals => '音频信号';

  @override
  String get selectAudioScheme => '更改音频信号方案';

  @override
  String get runSettings => '运行设置';

  @override
  String get notifyUponReachedBreaks => '休息点到达时通知';

  @override
  String get notifyUponReachedBreaksDescription => '休息点到达及运行开始或结束时通知。';

  @override
  String get vibrateUponReachedBreaks => '休息点到达时振动';

  @override
  String get vibrateUponReachedBreaksDescription => '休息点到达及运行开始或结束时按特定模式振动。';

  @override
  String get signalTwiceUponReachedBreaks => '休息点到达时发出两次信号';

  @override
  String get signalTwiceUponReachedBreaksDescription => '为确保不错过休息，每个休息点都会发出两次信号。';

  @override
  String get signalWithoutCounter => '没有计数器信息的信号';

  @override
  String get signalWithoutCounterDescription => '音频和振动信号中不包含计数器信息。';

  @override
  String get defaultBreakOrder => '休息点顺序默认为递减';

  @override
  String get defaultBreakOrderDescription => '休息点顺序为 …, 3, 2, 1，而非 1, 2, 3…。';

  @override
  String get showRunSpinner => '显示运行指示器';

  @override
  String get showRunSpinnerDescription => '定时器运行时，在定时器轮盘中显示旋转指示器。';

  @override
  String get showArrowsOnTimeValues => '在时间值旁显示箭头';

  @override
  String get showArrowsOnTimeValuesDescription => '在定时器运行时，在时间值旁显示箭头以指示其变化方向。';

  @override
  String get presetSettings => '预设设置';

  @override
  String get hidePredefinedPresets => '隐藏预定义的预设';

  @override
  String get hidePredefinedPresetsDescription => '如果您不需要预定义的预设，可将其隐藏，仅显示您自己的自定义预设。';

  @override
  String get customizedPresetsOnTop => '在顶部显示自定义预设';

  @override
  String get customizedPresetsOnTopDescription => '自定义预设显示在预设列表顶部以便快速访问。';

  @override
  String get appBehaviourSettings => '应用行为设置';

  @override
  String get activateWakeLock => '激活唤醒锁定';

  @override
  String get activateWakeLockDescription => '唤醒锁定可防止屏幕自动关闭。';

  @override
  String get startAppFromScratch => '启动应用时使用空白定时器轮盘';

  @override
  String get startAppFromScratchDescription => '应用启动时将使用空白定时器轮盘或首选预设。如果禁用此选项，应用启动时将恢复上次使用状态。';

  @override
  String get clockModeAsDefault => '默认使用时钟模式';

  @override
  String get clockModeAsDefaultDescription => '默认设置为时钟模式而非定时器模式';

  @override
  String get info => '信息';

  @override
  String get batteryOptimizations => '电池优化';

  @override
  String get aboutTheApp => '关于应用';

  @override
  String get appShortDescription => '支持中间通知的定时器';

  @override
  String visitAppGithubPage(Object url) {
    return '访问 $url 查看代码、报告错误和评分！';
  }

  @override
  String visitAppHomePage(Object url) {
    return '访问 $url 了解更多信息。';
  }

  @override
  String get help => '帮助';

  @override
  String get appSummary => '本定时器支持设置任意数量的中间通知（“休息点”），帮助您掌握时间进度。';

  @override
  String get appExplanation => '点击定时器轮盘中心选择定时器的时长或时间。点击轮盘刻度段可在定时器轮盘上选择任意数量的休息点。每个休息点都会生成信号（声音和/或振动），并对应以下专属模式（点击即可播放）：';

  @override
  String breakReached(Object breakCount, Object breakNumber) {
    return '到达第 $breakNumber 个休息点，共 $breakCount 个';
  }

  @override
  String get timerStarted => '计时开始';

  @override
  String get timerFinished => '计时结束';

  @override
  String get timerFinishedButRepeating => '计时结束，但会重复';

  @override
  String afterDuration(Object duration) {
    return '$duration 后';
  }

  @override
  String afterXRuns(Object runCount) {
    return '$runCount 次运行后';
  }

  @override
  String withBreaks(Object breakCount) {
    return '有 $breakCount 个休息点';
  }

  @override
  String get breakPresets => '休息点预设';

  @override
  String breakPresetPinned(Object preset) {
    return '预设“$preset”已固定';
  }

  @override
  String breakPresetUnpinned(Object preset) {
    return '预设“$preset”已取消固定';
  }

  @override
  String get every3rdSlice => '每 3 个分段';

  @override
  String get every5thSlice => '每 5 个分段';

  @override
  String everyXMinutes(Object count) {
    return '每 $count 分钟';
  }

  @override
  String get savePresetTitle => '保存预设';

  @override
  String get savePresetMessage => '输入要保存的预设名称。';

  @override
  String get savePresetHint => '输入名称';

  @override
  String get savePresetIncludeDuration => '包括时长';

  @override
  String get savePresetIncludeTime => '包括时间';

  @override
  String get errorSavePresetNameMissing => '缺少预设名称';

  @override
  String get errorSavePresetNameInUse => '预设名称已被使用，请选择其他名称';

  @override
  String savePresetDone(Object preset) {
    return '“$preset”已保存';
  }

  @override
  String get removePresetTitle => '移除已保存的预设';

  @override
  String removePresetMessage(Object preset) {
    return '确定要永久删除“$preset”？';
  }

  @override
  String removePresetDone(Object preset) {
    return '“$preset”已移除';
  }

  @override
  String get breakOrderSwitchedToAscending => '休息点顺序已更改为升序';

  @override
  String get breakOrderSwitchedToDescending => '休息点顺序已更改为降序';

  @override
  String get startTimer => '开始';

  @override
  String get stopTimer => '停止';

  @override
  String get swipeToStop => '滑动即可停止';

  @override
  String get repeatOnce => '单次重复';

  @override
  String get repeatForever => '无限重复';

  @override
  String get noRepeat => '不重复';

  @override
  String xBreaksPlaced(Object breakCount) {
    return '已设置 $breakCount 个休息点';
  }

  @override
  String xBreaksPlacedRepeatOnce(Object breakCount) {
    return '已设置 $breakCount 个休息点，单次重复';
  }

  @override
  String xBreaksPlacedRepeatForever(Object breakCount) {
    return '已设置 $breakCount 个休息点，无限重复';
  }

  @override
  String xBreaksLeft(Object breakCount, Object remainingBreaks) {
    return '还剩 $remainingBreaks 个休息点，共 $breakCount 个';
  }

  @override
  String xBreaksLeftRepeatOnce(Object breakCount, Object remainingBreaks, Object runCount) {
    return '还剩 $remainingBreaks 个休息点，共 $breakCount 个，单次重复（运行 $runCount 次，共 2 次）';
  }

  @override
  String xBreaksLeftRepeatForever(Object breakCount, Object remainingBreaks, Object runCount) {
    return '还剩 $remainingBreaks 个休息点，共 $breakCount 个，无限重复（运行 $runCount 次）';
  }

  @override
  String get splitBreaks => '拆分休息点';

  @override
  String splitBreaksDescription(Object duration) {
    return '选择 $duration 所需的休息点数量。';
  }

  @override
  String durationBetweenBreaks(Object breakCount, Object duration) {
    return '$breakCount 个休息点的间隔时长：$duration';
  }

  @override
  String get errorNoPermissionForNotifications => '未授予此权限，通知将无法正常工作。';

  @override
  String get errorDeviceMuted => '设备已静音。请先取消静音以设置音量。';

  @override
  String errorMaxBreaksReached(Object maxBreakCount) {
    return '最多允许 $maxBreakCount 个休息点';
  }

  @override
  String get errorNoBreaksToReset => '无休息点可重置';

  @override
  String get errorClockTimeToClose => '定时时间必须设置为未来一分钟之后。';

  @override
  String get errorDurationIsZero => '时长不能为零。';

  @override
  String get errorTimeAlreadyElapsed => '定时时间已到，请设置新定时器。';
}
