import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bdt/main.dart';
import 'package:bdt/service/BreakDownService.dart';
import 'package:bdt/service/LocalNotificationService.dart';
import 'package:bdt/service/PreferenceService.dart';
import 'package:bdt/service/SignalService.dart';
import 'package:bdt/ui/utils.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slider_button/slider_button.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:system_clock/system_clock.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../model/BreakDown.dart';
import '../service/ColorService.dart';
import '../util/dates.dart';
import '../util/prefs.dart';
import 'SettingsScreen.dart';
import 'VolumeSliderDialog.dart';
import 'dialogs.dart';

class BDTScaffold extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return BDTScaffoldState();
  }
}

enum TimerMode {RELATIVE, ABSOLUTE}
enum Direction {ASC, DESC}
enum RunMode {NO_REPEAT, REPEAT_ONCE, REPEAT_FOREVER}
enum RelativeProgressPresentation {ALL, REMAINING, PROGRESSING, REMAINING_PRORESSING}
enum AbsoluteProgressPresentation {ALL, START_CURRENT, CURRENT_END}


final MAX_BREAKS = 20;
final MAX_SLICE = 60;
final CENTER_RADIUS = 60.0;

class BDTScaffoldState extends State<BDTScaffold> with SingleTickerProviderStateMixin {

  final HOMEPAGE = 'bdt.jepfa.de';
  final HOMEPAGE_SCHEME = 'https://';

  int _touchedIndex = -1;
  int _passedIndex = -1;

  Duration _duration = kReleaseMode ? const Duration(minutes: 60): const Duration(seconds: 60);
  Duration? _originDuration;
  late DateTime _time;
  DateTime? _originTime;

  final _selectedSlices = HashSet<int>();
  int? _pinnedBreakDownId;

  TimerMode _timerMode = TimerMode.RELATIVE;
  Direction _direction = Direction.ASC;
  RunMode _runMode = RunMode.NO_REPEAT;
  int _repetition = 0;
  RelativeProgressPresentation _relativeProgressPresentation = RelativeProgressPresentation.ALL;
  AbsoluteProgressPresentation _absoluteProgressPresentation = AbsoluteProgressPresentation.ALL;

  List<BreakDown> _loadedBreakDowns = List.of(predefinedBreakDowns);
  BreakDown? _selectedBreakDown = null;
  bool _hasDurationChangedForCurrentBreakDown = false;
  bool _hasTimeChangedForCurrentBreakDown = false;

  final _notificationService = LocalNotificationService();
  final _preferenceService = PreferenceService();
  Timer? _runTimer;
  DateTime? _startedAt;
  int _volume = MAX_VOLUME;
  RingerModeStatus _ringerStatus = RingerModeStatus.unknown;

  late AnimationController _circleAnimationController;
  bool _circleAnimationDirection = false;
  double _circleAnimationLastValue = 0;

  @pragma('vm:entry-point')
  static Future<void> signal1() async {
    debugPrint('sig 1');

    await notifySignal(1);
    await SignalService.makeSignalPattern(SIG_1);
  }

  @pragma('vm:entry-point')
  static Future<void> signal2() async {
    debugPrint('sig 2');

    await notifySignal(2);
    await SignalService.makeSignalPattern(SIG_2);
  }

  @pragma('vm:entry-point')
  static Future<void> signal3() async {
    debugPrint('sig 3');

    await notifySignal(3);
    await SignalService.makeSignalPattern(SIG_3);
  }

  @pragma('vm:entry-point')
  static Future<void> signal4() async {
    debugPrint('sig 4');

    await notifySignal(4);
    await SignalService.makeSignalPattern(SIG_4);
  }

  @pragma('vm:entry-point')
  static Future<void> signal5() async {
    debugPrint('sig 5');

    await notifySignal(5);
    await SignalService.makeSignalPattern(SIG_5);
  }

  @pragma('vm:entry-point')
  static Future<void> signal6() async {
    debugPrint('sig 6');

    await notifySignal(6);
    await SignalService.makeSignalPattern(SIG_6);
  }

  @pragma('vm:entry-point')
  static Future<void> signal7() async {
    debugPrint('sig 7');

    await notifySignal(7);
    await SignalService.makeSignalPattern(SIG_7);
  }

  @pragma('vm:entry-point')
  static Future<void> signal8() async {
    debugPrint('sig 8');

    await notifySignal(8);
    await SignalService.makeSignalPattern(SIG_8);
  }

  @pragma('vm:entry-point')
  static Future<void> signal9() async {
    debugPrint('sig 9');

    await notifySignal(9);
    await SignalService.makeSignalPattern(SIG_9);
  }

  @pragma('vm:entry-point')
  static Future<void> signal10() async {
    debugPrint('sig 10');

    await notifySignal(10);
    await SignalService.makeSignalPattern(SIG_10);
  }

  @pragma('vm:entry-point')
  static Future<void> signal11() async {
    debugPrint('sig 11');

    await notifySignal(11);
    await SignalService.makeSignalPattern(SIG_11);
  }

  @pragma('vm:entry-point')
  static Future<void> signal12() async {
    debugPrint('sig 12');

    await notifySignal(12);
    await SignalService.makeSignalPattern(SIG_12);
  }

  @pragma('vm:entry-point')
  static Future<void> signal13() async {
    debugPrint('sig 13');

    await notifySignal(13);
    await SignalService.makeSignalPattern(SIG_13);
  }

  @pragma('vm:entry-point')
  static Future<void> signal14() async {
    debugPrint('sig 14');

    await notifySignal(14);
    await SignalService.makeSignalPattern(SIG_14);
  }

  @pragma('vm:entry-point')
  static Future<void> signal15() async {
    debugPrint('sig 15');

    await notifySignal(15);
    await SignalService.makeSignalPattern(SIG_15);
  }

  @pragma('vm:entry-point')
  static Future<void> signal16() async {
    debugPrint('sig 16');

    await notifySignal(16);
    await SignalService.makeSignalPattern(SIG_16);
  }

  @pragma('vm:entry-point')
  static Future<void> signal17() async {
    debugPrint('sig 17');

    await notifySignal(17);
    await SignalService.makeSignalPattern(SIG_17);
  }

  @pragma('vm:entry-point')
  static Future<void> signal18() async {
    debugPrint('sig 18');

    await notifySignal(18);
    await SignalService.makeSignalPattern(SIG_18);
  }

  @pragma('vm:entry-point')
  static Future<void> signal19() async {
    debugPrint('sig 19');

    await notifySignal(19);
    await SignalService.makeSignalPattern(SIG_19);
  }

  @pragma('vm:entry-point')
  static Future<void> signal20() async {
    debugPrint('sig 20');

    await notifySignal(20);
    await SignalService.makeSignalPattern(SIG_20);
  }

  @pragma('vm:entry-point')
  static Future<void> signalEndWithRepetition() async {
    debugPrint('sig end and repeat');
    await notify(100, 'Timer finished but repeating', fixed: true, showBreakInfo: false, showProgress: true);
    await SignalService.makeSignalPattern(SIG_END);
  }

  @pragma('vm:entry-point')
  static Future<void> signalEnd() async {
    debugPrint('sig end');
    await notify(100, 'Timer finished', showBreakInfo: true, showProgress: true);
    await SignalService.makeSignalPattern(SIG_END);
  }

  Function _signalFunction(int signal) {
    int s = signal;
    if (_direction == Direction.DESC) {
      s = _selectedSlices.length + 1 - signal;
    }
    debugPrint('signal=$signal s=$s');
    switch (s) {
      case 1: return signal1;
      case 2: return signal2;
      case 3: return signal3;
      case 4: return signal4;
      case 5: return signal5;
      case 6: return signal6;
      case 7: return signal7;
      case 8: return signal8;
      case 9: return signal9;
      case 10: return signal10;
      case 11: return signal11;
      case 12: return signal12;
      case 13: return signal13;
      case 14: return signal14;
      case 15: return signal15;
      case 16: return signal16;
      case 17: return signal17;
      case 18: return signal18;
      case 19: return signal19;
      case 20: return signal20;
    }
    throw Exception('unknown signal $signal');
  }

  static Future<void> notifySignal(int signal) async {
    final prefService = PreferenceService();
    final breaksCount = await getBreaksCount(prefService);

    final signalAsString = _breakNumberToString(signal);
    await notify(signal, 'Break $signalAsString of $breaksCount reached',
        showProgress: true, showBreakInfo: true, fixed: true);
  }

  static String _breakNumberToString(int signal) => signal <= 10 ? signal.toString() : '10+${signal-10} ($signal)';

  static Future<void> notify(int id, String msg, {
    PreferenceService? preferenceService, 
    LocalNotificationService? notificationService,
    bool showProgress = false, 
    bool showBreakInfo = false, 
    bool showStartInfo = false,
    bool fixed = false,
  }) async {
    final prefService = preferenceService ?? PreferenceService();
    if (await mayNotify(prefService) != true) {
      debugPrint('notification disabled');
      return;
    }
    final _notificationService = notificationService ?? LocalNotificationService();
    if (notificationService != null) {
      await _notificationService.init();
    }
    _notificationService.cancelAllNotifications();
    var message = msg;
    int? progress = null;
    final now = DateTime.now();
    if (showBreakInfo) {
      progress = await getProgress(prefService);
      final startedAt = await getStartedAt(prefService);
      if (startedAt != null) {
        final duration = startedAt.difference(now).abs();
        message = '$msg after ${formatDuration(duration)}';
      }
    }
    else if (showStartInfo) {
      final breaksCount = await getBreaksCount(prefService);
      message = '$msg with $breaksCount breaks';
    }

    _notificationService.showNotification('', id, APP_NAME_SHORT, message, 'bdt_signals',
        showProgress, fixed, progress, '', ColorService().getCurrentScheme().button);
  }

  @override
  void initState() {
    super.initState();

    _time = _deriveTime();
    _notificationService.init();

    _updateBreakOrder();
    _updateWakeLock();

    getVolume(_preferenceService).then((value) {
      setState(() => _volume = value);
    });
    SoundMode.ringerModeStatus.then((value) => _ringerStatus = value);

    _preferenceService.getInt(PreferenceService.PREF_TIMER_PROGRESS_PRESENTATION).then((value) {
      if (value != null) {
        _relativeProgressPresentation = RelativeProgressPresentation.values.elementAt(value);
      }
    });
    _preferenceService.getInt(PreferenceService.PREF_CLOCK_PROGRESS_PRESENTATION).then((value) {
      if (value != null) {
        _absoluteProgressPresentation = AbsoluteProgressPresentation.values.elementAt(value);
      }
    });

    Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          SoundMode.ringerModeStatus.then((value) => _ringerStatus = value);
         // debugPrint('refresh ui values');
        });
      }
    });

    getRunState(_preferenceService).then((persistedState) {
      if (persistedState != null) {
        Map<String, dynamic> stateAsJson = jsonDecode(persistedState);
        debugPrint('!!!!!!FOUND persisted state: $stateAsJson');
        final lastBoot = DateTime.now().subtract(SystemClock.elapsedRealtime());
        var startedAtFromJson = stateAsJson['startedAt'];
        if (startedAtFromJson != null) {
          final persistedStateFrom = DateTime.fromMillisecondsSinceEpoch(
              startedAtFromJson);
          debugPrint('last boot was ${formatDateTime(
              lastBoot)}, persisted state is from ${formatDateTime(
              persistedStateFrom)}');
          if (lastBoot.isBefore(persistedStateFrom)) {
            debugPrint('State is from this session, using it');
            _setStateFromJson(stateAsJson);
            _startTimer();
            int? preSelectedBreakDownId = stateAsJson['selectedBreakDown'];
            _loadBreakDowns(focusPinned: false, preSelectedBreakDownId: preSelectedBreakDownId);
          }
          else {
            debugPrint('State is outdated, deleting it');
            setRunState(_preferenceService, null);
            int? preSelectedBreakDownId = stateAsJson['selectedBreakDown'];
            _loadBreakDowns(focusPinned: true, preSelectedBreakDownId: preSelectedBreakDownId);
          }
        }
        else {
          _preferenceService.getBool(PreferenceService.PREF_CLEAR_STATE_ON_STARTUP).then((startWithoutStateRecovery) async {
            if (startWithoutStateRecovery == true) {
              final useClockMode = await _preferenceService.getBool(PreferenceService.PREF_CLOCK_MODE_AS_DEFAULT);
              if (useClockMode == true) {
                _timerMode = TimerMode.ABSOLUTE;
              }
              _loadBreakDowns(focusPinned: true);
            }
            else {
              debugPrint('Recover last session');
              _setStateFromJson(stateAsJson);
              int? preSelectedBreakDownId = stateAsJson['selectedBreakDown'];
              _loadBreakDowns(focusPinned: true,
                  preSelectedBreakDownId: preSelectedBreakDownId);
            }
          });
        }
      }
    });
    


    _preferenceService.getBool(PreferenceService.DATA_BATTERY_SAVING_RESTRICTIONS_HINT_DISMISSED)
        .then((dismissed) {
          if (dismissed != true) {
            DisableBatteryOptimization.isBatteryOptimizationDisabled.then((isDisabled) {
              if (isDisabled != true) {
                DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
              }
            });
          }
    });

    _notificationService.requestPermissions();

    _circleAnimationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    Tween<double>(begin: 0, end: 1).animate(_circleAnimationController)
      ..addListener(() {
        setState(() {
          final circleAnimationCurrentValue = _circleAnimationController.value;
          if (_circleAnimationLastValue > circleAnimationCurrentValue) {
            _circleAnimationDirection = !_circleAnimationDirection;
          }
          _circleAnimationLastValue = circleAnimationCurrentValue;
        });
      });

  }

  void _askForNotification() {
    mayNotify(_preferenceService).then((allowedToNotify) {
      if (allowedToNotify) {
        Permission.notification.request().then((status) {
          debugPrint("notification permission = $status");
          if (status != PermissionStatus.granted) {
            toastInfo(context, "Notifications won't work as long as permission is not granted.");
          }
        });
      }
    });
  }

  void _loadBreakDowns({required bool focusPinned, int? preSelectedBreakDownId = null}) {
    BreakDownService().getAllBreakDowns(
        userPresetsOnTop: _preferenceService.userPresetsOnTop,
        hidePredefinedPresets:  _preferenceService.hidePredefinedPresets,
    )
        .then((value) {
          setState(() {
            _loadedBreakDowns = value;
            if (preSelectedBreakDownId != null) {
              _selectedBreakDown = value.firstWhere((b) => b.id == preSelectedBreakDownId);
            }

            if (focusPinned) {
              getPinnedBreakDown(_preferenceService).then((pinnedId) {
                _pinnedBreakDownId = pinnedId;
                if (pinnedId != null) {
                  final candidates = value.where((e) => e.id == pinnedId);
                  if (candidates.isNotEmpty) {
                    _updateSelectedSlices(candidates.first);
                  }
                }
              });
            }
            else if ( _preferenceService.hidePredefinedPresets && (_selectedBreakDown?.isPredefined()??false)) {
              // currentSelection is hidden
              _updateSelectedSlices(null);
            }
          });
        });
  }

  Future<void> _updateBreakOrder() async {
    final isDescending = await _preferenceService.getBool(PreferenceService.PREF_BREAK_ORDER_DESCENDING);

    if (isDescending == true) {
      _direction = Direction.DESC;
    }
    else {
      _direction = Direction.ASC;
    }
  }

  Future<void> _updateWakeLock() async {
    final hasWakeLock = await _preferenceService.getBool(PreferenceService.PREF_WAKE_LOCK);

    if (hasWakeLock == true) {
      WakelockPlus.enable();
    }
    else {
      WakelockPlus.disable();
    }

  }

  _startTimer() {
    _startSpinner();

    _runTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_isCurrentRunOver()) {
        if (_isRepeating()) {
          _repetition++;
          _startedAt = DateTime.now();
          _time = _time.add(_duration);
          _persistState();
          _scheduleSliceNotifications();
        }
        else {
          timer.cancel();
        }
      }
      if (mounted) {
        _updateRunning();
        //debugPrint('.. timer refresh #${_runTimer?.tick} ..');
      }
    });
  }

  void _updateRunning() {
    final progress = _getProgress();
    setProgress(_preferenceService, progress != null ? (progress * 100).round() : null);
    setStartedAt(_preferenceService, _startedAt);
    setBreaksCount(_preferenceService, _selectedSlices.length);
    
    final delta = _getDelta();
    if (delta != null) {
      final ratio = delta.inSeconds / _duration.inSeconds;
      //debugPrint('delta=$delta, ratio = $ratio');
      setState(() {
        _passedIndex = (MAX_SLICE * ratio).floor() + 1;
        // update all
      });
    }
  }

  bool _isAllRunsOver() {
    if (_isRunning() && _isRepeating()) {
      // in case of repeating and not stopped runs nothing is over
      return false;
    }
    return _isCurrentRunOver();
  }

  bool _isCurrentRunOver() {
    final now = DateTime.now();
    return _startedAt?.add(_duration).isBefore(now) ?? false;
  }

  DateTime? _getFinalTime() => _startedAt?.add(_duration);

  Duration? _getDelta() {
    final now = DateTime.now();
    return _startedAt?.difference(now).abs();
  }

  Duration? _getRemaining() {
    final finalTime = _getFinalTime();
    final now = DateTime.now();
    if (finalTime == null) {
      return null;
    }
    return Duration(seconds: finalTime.difference(now).abs().inSeconds + 1);
  }

  double? _getProgress() {
    final progressed = _getDelta();
    if (progressed != null) {
      return progressed.inSeconds / _duration.inSeconds;
    }
    else {
      return null;
    }
  }

  _stopTimer() {
    _runTimer?.cancel();
    setState(() {
      _startedAt = null;
      _repetition = 0;
      _passedIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FGBGNotifier(
      onEvent: (event) {
        if (event == FGBGType.background) {
          debugPrint('App goes background');
          _persistState();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(APP_NAME_SHORT),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        List<Widget> rows = new List<int>.generate(MAX_BREAKS, (i) => i + 1)
                        .map((i) => GestureDetector(
                          onTapUp: (_) {
                            SignalService.makeSignalPattern(_getSignalForNumber(i),
                                volume: _volume,
                                neverSignalTwice: true,
                                signalAlthoughCancelled: true,
                                preferenceService: _preferenceService);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
                                child: _getIconForNumber(i, MAX_BREAKS, forceAsc: true)!,
                              ),
                              Text('Break ${_breakNumberToString(i)}: ',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              Text(_getSignalStringForNumber(i), style: const TextStyle(fontSize: 10),),
                            ]),
                        ))
                              .toList();

                          rows.add(GestureDetector(
                            onTapUp: (_) {
                              SignalService.makeSignalPattern(_getSignalForNumber(100),
                                  volume: _volume,
                                  neverSignalTwice: true,
                                  signalAlthoughCancelled: true,
                                  preferenceService: _preferenceService);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                                  child: Text(''),
                                ),
                                const Text('Timer end: ',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                Text(_getSignalStringForNumber(100), style: const TextStyle(fontSize: 10),),
                              ]),
                          )
                        );

                        rows.add(GestureDetector(
                          child: const Row(
                              children: [Text('')])));

                        rows.add(GestureDetector(
                          child: Row(
                            children: [
                              InkWell(
                                  child: Text.rich(
                                    TextSpan(
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                                      text: 'Visit ',
                                      children: <TextSpan>[
                                        TextSpan(text: HOMEPAGE, style: const TextStyle(decoration: TextDecoration.underline)),
                                        const TextSpan(text: ' for more information.'),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    launchUrlString(HOMEPAGE_SCHEME + HOMEPAGE, mode: LaunchMode.externalApplication);
                                  }),
                            ],
                          ),
                        ));

                        return AlertDialog(
                          insetPadding: EdgeInsets.zero,
                          contentPadding: const EdgeInsets.all(16),
                          title: const Column(
                            children: [
                              Text('Help'),
                              Text(''),
                              Text('With this timer you can define relative in-between notifications to get informed about the progress of the passed timer time.',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                              Text('Choose a duration or a timer time by clicking on the center of the wheel and select breaks on the wheel by clicking on a slice. A break is just an acoustic signal and/or vibration with a unique pattern like follows (click on it to play):',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                            ],
                          ),
                          content: Builder(
                            builder: (context) {
                              var height = MediaQuery.of(context).size.height;
                              var width = MediaQuery.of(context).size.width;

                              return Container(
                                height: height - 100,
                                width: width - 4,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: rows,
                                  ),
                                ),
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Close'),
                              onPressed:  () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      }
                  );
                },
                icon: const Icon(Icons.help_outline)),
            IconButton(
                onPressed: () async {
                  _ringerStatus = await SoundMode.ringerModeStatus;
                  setState((){});
                  if (_isDeviceMuted()) {
                    toastInfo(context, 'Device is muted. Unmute first to set volume.');
                    return;
                  }

                  final volume = await showVolumeSliderDialog(context,
                    initialSelection: _volume.toDouble(),
                    onChangedEnd: (value) {
                      SignalService.setSignalVolume(value.round());
                      SignalService.makeShortSignal();
                    }
                  );
                  if (volume != null) {
                    setState(() {
                      _volume = volume.round();
                      setVolume(_preferenceService, _volume);
                    }); // update
                  }
                  SignalService.setSignalVolume(_volume);
                },
                icon: _isDeviceMuted() ? const Icon(Icons.volume_off) : createVolumeIcon(_volume)),
            IconButton(
                onPressed: () {
                  Navigator.push(super.context, MaterialPageRoute(builder: (context) => SettingsScreen()))
                      .then((value) {
                        _loadBreakDowns(focusPinned: false);
                        _updateWakeLock();
                        setState(() => _updateBreakOrder());
                      });
                },
                icon: const Icon(Icons.settings)),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: IconButton(
                        onPressed: () => _moveBreakDownSelectionToNext(),
                        color: _isRunning() || _isBreakDownSelectionAtStart() ? Colors.grey[700] : ColorService().getCurrentScheme().button,
                        icon: const Icon(Icons.arrow_back_ios),
                      )),
                  Expanded(
                    flex: 9,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragEnd: (details) {
                        // Swiping in left direction.
                        if (details.velocity.pixelsPerSecond.dx < 0) {
                          _moveBreakDownSelectionToPrevious();
                        }

                        // Swiping in right direction.
                        if (details.velocity.pixelsPerSecond.dx > 0) {
                          _moveBreakDownSelectionToNext();
                        }
                      },
                      child: DropdownButtonFormField<BreakDown?>(
                        isDense: true,
                        focusColor: ColorService().getCurrentScheme().accent,
                        onTap: () => FocusScope.of(context).unfocus(),
                        value: _loadedBreakDowns.contains(_selectedBreakDown) ? _selectedBreakDown : null,
                        hint: const Text('Break downs'),
                        iconEnabledColor: ColorService().getCurrentScheme().button,
                        icon: const ImageIcon(AssetImage('assets/launcher_bdt_adaptive_fore.png')),
                        isExpanded: true,
                        onChanged:  _isRunning() ? null : (value) {
                          _updateSelectedSlices(value);
                        },
                        items: _loadedBreakDowns.map((BreakDown breakDown) {
                          return DropdownMenuItem(
                            value: breakDown,
                            child: breakDown.id == _pinnedBreakDownId
                                ? Row(children: [
                                        Icon(Icons.push_pin, color: _isRunning() ? Colors.grey : null,),
                                        Text(breakDown.getPresetName())
                                  ])
                                : Text(breakDown.getPresetName()),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Flexible(child: IconButton(
                    color: _isRunning() || _isBreakDownSelectionAtEnd() ? Colors.grey[700] : ColorService().getCurrentScheme().button,
                    onPressed: () => _moveBreakDownSelectionToPrevious(),
                    icon: const Icon(Icons.arrow_forward_ios),
                  )),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragEnd: _switchTimerMode,
              child: CupertinoSlidingSegmentedControl<TimerMode>(
                backgroundColor: ColorService().getCurrentScheme().background,
                thumbColor: ColorService().getCurrentScheme().button,
                padding: const EdgeInsets.all(8),
                children: <TimerMode, Widget> {
                  TimerMode.RELATIVE: Icon(Icons.timer_outlined,
                      color: _timerMode == TimerMode.RELATIVE ? ColorService().getCurrentScheme().accent : ColorService().getCurrentScheme().button),
                  TimerMode.ABSOLUTE: Icon(Icons.alarm,
                      color: _timerMode == TimerMode.ABSOLUTE ? ColorService().getCurrentScheme().accent : ColorService().getCurrentScheme().button),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() => _setTimerMode(value));
                  }
                },
                groupValue: _timerMode,
              ),
            ),
            AspectRatio(
              aspectRatio: 0.97,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragEnd: _switchTimerMode,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                if (_isRunning()) {
                                  return;
                                }
                                if (event is FlTapUpEvent
                                    || event is FlPointerExitEvent
                                    || event is FlLongPressEnd
                                    || event is FlPanEndEvent
                                ) {
                                  setState(() {
                                    _touchedIndex = 0;
                                  });
                                }
                                else if (event is FlTapDownEvent) {
                                  setState(() {
                                    if (
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection == null) {
                                      _touchedIndex = -1;
                                      return;
                                    }
                                    _touchedIndex =
                                        (pieTouchResponse.touchedSection!
                                            .touchedSectionIndex + 1) % MAX_SLICE;
                                    debugPrint('_touchedIndex=$_touchedIndex');
                                    if (_touchedIndex != 0) {
                                      if (_selectedSlices.contains(
                                          _touchedIndex)) {
                                        _selectedSlices.remove(_touchedIndex);
                                        _persistState();
                                      }
                                      else {
                                        if (_selectedSlices.length < MAX_BREAKS) {
                                          _selectedSlices.add(_touchedIndex);
                                          _persistState();
                                        }
                                        else {
                                          toastError(context,
                                              'max $MAX_BREAKS breaks allowed');
                                        }
                                      }
                                    }
                                    debugPrint('_selected=$_selectedSlices');
                                  });
                                }
                              }),
                          borderData: FlBorderData(
                              show: false
                          ),
                          sectionsSpace: 1,
                          centerSpaceRadius: CENTER_RADIUS,
                          sections: _createSections(),
                          startDegreeOffset: 270 + 2.5
                      ),
                      swapAnimationDuration: const Duration(milliseconds: 75),
                    ),
                    Center(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: SizedBox(
                          width: CENTER_RADIUS * 1.8,
                          height: CENTER_RADIUS * 1.8,
                          child: Center(child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (_preferenceService.showSpinner && (_isRunning() && !_isAllRunsOver()))
                                  Center(
                                    child: SizedBox.expand(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          strokeCap: StrokeCap.round,
                                          color: _circleAnimationDirection ? ColorService().getCurrentScheme().background : ColorService().getCurrentScheme().button,
                                          backgroundColor: _circleAnimationDirection ? ColorService().getCurrentScheme().button : ColorService().getCurrentScheme().background,
                                          value: _circleAnimationController.value
                                        ),
                                    ),
                                  ),
                                Center(child: _createCycleWidget()),
                              ],)
                          )),
                        onTap: () {
                          if (_isRunning()) {
                            setState(() {
                              if (_timerMode == TimerMode.RELATIVE) {
                                final index = _relativeProgressPresentation.index + 1;
                                _relativeProgressPresentation =
                                    RelativeProgressPresentation.values.elementAt(index % RelativeProgressPresentation.values.length);
                                _preferenceService.setInt(PreferenceService.PREF_TIMER_PROGRESS_PRESENTATION, _relativeProgressPresentation.index);
                              }
                              else if (_timerMode == TimerMode.ABSOLUTE) {
                                final index = _absoluteProgressPresentation.index + 1;
                                _absoluteProgressPresentation =
                                    AbsoluteProgressPresentation.values.elementAt(index % AbsoluteProgressPresentation.values.length);
                                _preferenceService.setInt(PreferenceService.PREF_CLOCK_PROGRESS_PRESENTATION, _absoluteProgressPresentation.index);
                              }
                            });
                          }
                          else {
                            if (_timerMode == TimerMode.RELATIVE) {
                              _changeDuration(context);
                            }
                            else if (_timerMode == TimerMode.ABSOLUTE) {
                              _changeTime(context);
                            }
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: _selectedBreakDown != null,
                      child: Positioned(
                        top: 20,
                        left: 20,
                        child: IconButton(
                            color: _isRunning()  ? Colors.grey[700] : ColorService().getCurrentScheme().button,
                            onPressed: () {
                              if (_isRunning()) {
                                //toastError(context, _stopRunningMessage());
                                return;
                              }
                              if (_selectedBreakDown != null) {
                                setState(() {
                                  if (_isPinnedBreakDown()) {
                                    _pinnedBreakDownId = null;
                                    toastInfo(context, "Preset '${_selectedBreakDown?.getPresetName()}' unpinned");
                                  }
                                  else {
                                    _pinnedBreakDownId = _selectedBreakDown?.id;
                                    toastInfo(context, "Preset '${_selectedBreakDown?.getPresetName()}' pinned");
                                  }
                                  setPinnedBreakDown(_preferenceService, _pinnedBreakDownId);
                                });
                              }
                            },
                            icon: _isPinnedBreakDown()
                                ? const Icon(Icons.push_pin)
                                : const Icon(Icons.push_pin_outlined),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _canSaveUserPreset() || _canDeleteUserPreset(),
                      child: Positioned(
                        bottom: 20,
                        left: 20,
                        child: IconButton(
                            color: _isRunning()  ? Colors.grey[700] : ColorService().getCurrentScheme().button,
                            onPressed: () {
                              if (_isRunning()) {
                                //toastError(context, _stopRunningMessage());
                                return;
                              }
                              if (_canDeleteUserPreset()) {
                                final breakDownName = _selectedBreakDown?.getPresetName();
                                showConfirmationDialog(context, 'Delete saved preset', "Are you sure to delete '$breakDownName' permanently?",
                                okPressed: () {
                                  if (_selectedBreakDown != null) {
                                    BreakDownService().deleteBreakDown(_selectedBreakDown!);
                                    if (_isPinnedBreakDown()) {
                                      _pinnedBreakDownId = null;
                                      setPinnedBreakDown(
                                          _preferenceService, _pinnedBreakDownId);
                                    }

                                    _updateSelectedBreakDown(null); // this not in setState
                                    _selectedSlices.clear();
                                    _loadBreakDowns(focusPinned: true);
                                  }
                                  Navigator.pop(context);
                                  toastInfo(context, "'$breakDownName' deleted");
                                },
                                cancelPressed: () {
                                  Navigator.pop(context);
                                });
                              }
                              else {
                                var newName = _selectedBreakDown?.name;
                                var isPredefined = _selectedBreakDown?.isPredefined() == true;
                                if (isPredefined) {
                                  newName = newName != null ? newName + ' (modified)' : null;
                                }
                                final isTimerModeDuration = _timerMode == TimerMode.RELATIVE;
                                final isSwitched = ValueNotifier(
                                    _selectedBreakDown?.duration != null || _selectedBreakDown?.time != null);
                                showInputWithSwitchDialog(context,
                                    'Save preset', 'Enter a name for your preset to save.',
                                    initText: newName,
                                    hintText: 'choose a name',
                                    switchText: isTimerModeDuration
                                        ? 'Include duration\n(${formatDuration(_duration)})'
                                        : 'Include time\n(${formatTimeOfDay(TimeOfDay.fromDateTime(_time))})',
                                    isSwitched: isSwitched,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Preset name missing';
                                      }
                                      return null;
                                    },
                                    cancelPressed: () => Navigator.pop(context),
                                    okPressed: (input) async {

                                      final id = isPredefined ? null : _selectedBreakDown?.id;
                                      var newName = input.trim();
                                      final allBreakDowns = await BreakDownService().getAllBreakDowns();
                                      final foundWithSameName = allBreakDowns
                                          .where((e) => e.name == newName && e.id != id)
                                          .isNotEmpty;
                                      if (foundWithSameName) {
                                        Navigator.pop(context);
                                        toastError(context, 'Preset name still used. Choose another one');
                                        return;
                                      }

                                      final saveCurrentDuration = isSwitched.value && isTimerModeDuration;
                                      final saveCurrentTime = isSwitched.value && !isTimerModeDuration;

                                      BreakDown newBreakDown;
                                      if (saveCurrentDuration) {
                                        newBreakDown = BreakDown.withDuration(id??0, newName, Set.of(_selectedSlices), _duration);
                                      }
                                      else if (saveCurrentTime) {
                                        newBreakDown = BreakDown.withTime(id??0, newName, Set.of(_selectedSlices), TimeOfDay.fromDateTime(_time));
                                      }
                                      else {
                                        newBreakDown = BreakDown(id??0, newName, Set.of(_selectedSlices));
                                      }
                                      BreakDownService().saveBreakDown(newBreakDown).then((savedBreakDown) {
                                        _updateSelectedBreakDown(savedBreakDown); // this not in setState
                                        _loadBreakDowns(focusPinned: false); // here setState is called

                                        toastInfo(context, "'$newName' saved");
                                      });

                                      Navigator.pop(context);
                                    });
                              }
                            },
                            icon: _canDeleteUserPreset()
                                ? const Icon(Icons.delete_forever)
                                : const Icon(Icons.save),
                      )),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton(
                        color: _isRunning()  ? Colors.grey[700] : ColorService().getCurrentScheme().button,
                        onPressed: () async {
                          if (_isRunning()) {
                            //toastError(context, _stopRunningMessage());
                            return;
                          }
                          if (_selectedSlices.isEmpty) {
                            await _updateBreakOrder();
                            final useClockMode = await _preferenceService.getBool(PreferenceService.PREF_CLOCK_MODE_AS_DEFAULT);
                            setState(() {
                              // reset to defaults
                              _timerMode = useClockMode == true ? TimerMode.ABSOLUTE : TimerMode.RELATIVE;
                              _runMode = RunMode.NO_REPEAT;
                              _updateDuration(kReleaseMode ? const Duration(minutes: 60): const Duration(seconds: 60), fromUser: true);
                              _updateTime(_deriveTime(), fromUser: true);
                              _persistState();
                            });
                            toastInfo(context, 'No breaks to reset');
                          }
                          else {
                            setState(() {
                              _selectedSlices.clear();
                              _updateSelectedBreakDown(null);
                            });
                          }
                        },
                        icon: Icon(MdiIcons.restart)),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: IconButton(
                        color: _isRunning()  ? Colors.grey[700] : ColorService().getCurrentScheme().button,
                        onPressed: () {
                          if (_isRunning()) {
                            //toastError(context, _stopRunningMessage());
                            return;
                          }
                          setState(() {
                            _direction = (_direction == Direction.ASC ? Direction.DESC : Direction.ASC);
                            toastInfo(context, "Break order switched to ${_direction == Direction.ASC ? "ascending" : "descending"}");
                            _persistState();
                          });
                        },
                        icon: Icon(_direction == Direction.ASC ? Icons.north : _direction == Direction.DESC ? Icons.south : Icons.swap_vert)),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: _createStatsLine()),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _isRunning() && !_isAllRunsOver()
            ? _createSwipeToStopButton(context)
            : _createStartButton(context),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    debugPrint('App killed');
    _circleAnimationController.dispose();
    await _persistState(); //This might not work since App is killed before persist is done
    super.dispose();
  }

  bool _canDeleteUserPreset() => _selectedBreakDown != null
      && _selectedBreakDown?.isPredefined() == false
      && !_hasBreakDownChanged()
      && !_hasDurationChangedForCurrentBreakDown
      && !_hasTimeChangedForCurrentBreakDown;

  bool _canSaveUserPreset() => _hasBreakDownChanged() || _hasBreakDownDurationChanged() || _hasBreakDownTimeChanged();

  bool _hasBreakDownChanged() {
    return _selectedBreakDown?.getSlicesAsString() != _selectedSortedSlicesToString();
  }

  bool _hasBreakDownDurationChanged() {
    return _timerMode == TimerMode.RELATIVE && _selectedBreakDown?.duration != _duration;
  }

  bool _hasBreakDownTimeChanged() {
    return _timerMode == TimerMode.ABSOLUTE && _selectedBreakDown?.time != _time;
  }

  bool _isDeviceMuted() => _ringerStatus == RingerModeStatus.silent || _ringerStatus == RingerModeStatus.vibrate;

  void _switchTimerMode(DragEndDetails details) {
    // Swiping in right direction.
    if (details.velocity.pixelsPerSecond.dx > 0) {
      setState(() => _setTimerMode(TimerMode.RELATIVE));
    }

    // Swiping in left direction.
    if (details.velocity.pixelsPerSecond.dx < 0) {
      setState(() => _timerMode = TimerMode.ABSOLUTE);
    }
  }

  void _setTimerMode(TimerMode mode) {
    _timerMode = mode;
    _persistState();
  }

  bool _isBreakDownSelectionAtStart() {
    if (_loadedBreakDowns.isNotEmpty) {
      var currIndex = _selectedBreakDown == null ? -1 : _loadedBreakDowns
          .indexOf(_selectedBreakDown!);

      return currIndex <= 0;
    }
    return false;
  }

  bool _isBreakDownSelectionAtEnd() {
    if (_loadedBreakDowns.isNotEmpty) {
      var currIndex = _selectedBreakDown == null ? -1 : _loadedBreakDowns
          .indexOf(_selectedBreakDown!);

      return currIndex == _loadedBreakDowns.length - 1;
    }
    return false;
  }

  void _moveBreakDownSelectionToPrevious() {
    if (!_isRunning() && _loadedBreakDowns.isNotEmpty) {
      var currIndex = _selectedBreakDown == null ? -1 : _loadedBreakDowns
          .indexOf(_selectedBreakDown!);

      if (currIndex != -1) {
        currIndex = min(currIndex + 1, _loadedBreakDowns.length - 1);
      }
      else {
        currIndex = 0;
      }
      _updateSelectedSlices(_loadedBreakDowns[currIndex]);
    }
  }

  void _moveBreakDownSelectionToNext() {
    if (!_isRunning() && _loadedBreakDowns.isNotEmpty) {
      var currIndex = _selectedBreakDown == null ? -1 : _loadedBreakDowns
          .indexOf(_selectedBreakDown!);

      if (currIndex != -1) {
        currIndex = max(currIndex - 1, 0);
      }
      _updateSelectedSlices(_loadedBreakDowns[currIndex]);
    }
  }

  void _updateSelectedSlices(BreakDown? value) {
    setState(() {
      _updateSelectedBreakDown(value);
      _selectedSlices.clear();
      if (value != null) {
        _selectedSlices.addAll(value.slices.toList());
      }
      _persistState();
    });
  }

  void _updateSelectedBreakDown(BreakDown? value) {
    _hasDurationChangedForCurrentBreakDown = false;
    _hasTimeChangedForCurrentBreakDown = false;
    _selectedBreakDown = value;
    if (value != null) {
      setState(() {
        if (value.duration != null) {
          _updateDuration(value.duration!, fromUser: false);
          _timerMode = TimerMode.RELATIVE;
        }
        else {
          _restoreDuration();
        }

        if (value.time != null) {
            if (_originTime == null) {
              _originTime = _time;
            }
            _updateAndAdjustTime(value.time!, fromUser: false);
            _timerMode = TimerMode.ABSOLUTE;
        }
        else {
          _restoreTime();
        }

        _persistState();
      });
    }
    else {
      setState(() {
        _restoreDuration();
        _restoreTime();
      });
    }
  }

  void _restoreDuration() {
    if (_originDuration != null) {
      _duration = _originDuration!;
      _originDuration = null;
    }
  }

  void _restoreTime() {
    if (_originTime != null) {
      _time = _originTime!;
      _originTime = null;
    }
  }

  Widget _createSwipeToStopButton(BuildContext context) {
    return SliderButton(
      action: () {
        _stopRun(context);
      },
      backgroundColor: ColorService().getCurrentScheme().button,
      baseColor: ColorService().getCurrentScheme().primary,
      highlightedColor: ColorService().getCurrentScheme().accent,
      height: 48,
      width: 200,
      buttonSize: 48,
      shimmer: false,
      dismissThresholds: 0.99,
      label: Text('\u27A0 Swipe to Stop',
          style: TextStyle(letterSpacing: 0.7, fontWeight: FontWeight.w500, color: ColorService().getCurrentScheme().accent)),
      icon: Icon(Icons.stop, color: ColorService().getCurrentScheme().button),
    );
  }

  Widget _createStartButton(BuildContext context) {
    return Wrap(
      children: [
        PopupMenuButton<RunMode>(
            constraints: const BoxConstraints(),
            icon: _getRunModeIcon(_runMode, null),
            enabled: !_isRunning(),
            initialValue: _runMode,
            itemBuilder: (context) => <PopupMenuItem<RunMode>> [
              PopupMenuItem<RunMode>(
                  value: RunMode.REPEAT_ONCE,
                  child: _createMenuItem(RunMode.REPEAT_ONCE, 'Repeat once')),
              PopupMenuItem<RunMode>(
                  value: RunMode.REPEAT_FOREVER,
                  child: _createMenuItem(RunMode.REPEAT_FOREVER, 'Repeat forever')),
              PopupMenuItem<RunMode>(
                  value: RunMode.NO_REPEAT,
                  child: _createMenuItem(RunMode.NO_REPEAT, 'No repeat')),
            ],
          onSelected: (runMode) {
            setState(() {
              _runMode = runMode;
              _persistState();
            });
          },
        ),
        FloatingActionButton.extended(
          backgroundColor: ColorService().getCurrentScheme().button,
          splashColor: ColorService().getCurrentScheme().foreground,
          foregroundColor: ColorService().getCurrentScheme().accent,
          icon: Icon(_isAllRunsOver() ? MdiIcons.restart : _isRunning() ? Icons.stop : Icons.play_arrow),
          label: Text(_isAllRunsOver() ? 'Reset' : _isRunning() ? 'Stop' : 'Start'),
          onPressed: () {
            if (_isRunning()) {
              if (_isAllRunsOver()) {
                _stopRun(context);
              }
              else {
                showConfirmationDialog(
                  context,
                  'Stop run',
                  'Really want to stop the run before it is finished?',
                  icon: Icon(MdiIcons.stopCircle),
                  okPressed: () {
                    Navigator.pop(
                        context); // dismiss dialog, should be moved in Dialogs.dart somehow
                    _stopRun(context);
                  },
                  cancelPressed: () =>
                      Navigator.pop(
                          context), // dismiss dialog, should be moved in Dialogs.dart somehow
                );
              }
            }
            else {
              _startRun(context);
            }
          },
        ),
        const SizedBox(width: 46),
      ],
    );
  }

  Widget _createMenuItem(RunMode runMode, String text) {
    final isSelected = _runMode == runMode;
    return ListTile(
      leading: _getRunModeIcon(runMode, isSelected),
      title: Text(text, style: TextStyle(color: isSelected
          ? ColorService().getCurrentScheme().accent
          : ColorService().getCurrentScheme().foreground)),
    );
  }

  Widget _getRunModeIcon(RunMode runMode, bool? isSelected) {
    final color = _isRunning()
        ? Colors.grey[700]
        : (isSelected != null
          ? (isSelected
            ? ColorService().getCurrentScheme().accent
            : ColorService().getCurrentScheme().foreground)
          : ColorService().getCurrentScheme().button);
    switch (runMode) {
      case RunMode.NO_REPEAT: return Icon(isSelected != null ? MdiIcons.repeatOff : Icons.arrow_drop_down, color: color);
      case RunMode.REPEAT_ONCE: return Icon(Icons.repeat_one, color: color);
      case RunMode.REPEAT_FOREVER: return Icon(Icons.repeat, color: color);
    }
  }

  Widget _createStatsLine() {
    if (_isAllRunsOver()) {
      if (_runMode == RunMode.NO_REPEAT) {
        return const Text('Timer finished');
      }
      else {
        return Text('Timer finished after ${_repetition+1} runs');
      }
    }
    else if (_isRunning()) {
      final remainingBreaks = _selectedSlices
          .where((index) => index >= _passedIndex)
          .toList()
          .length;
      if (_runMode == RunMode.REPEAT_ONCE) {
        return Text('$remainingBreaks of ${_selectedSlices.length} breaks left, repeating once (run ${_repetition+1} of 2)');
      }
      else if (_runMode == RunMode.REPEAT_FOREVER) {
        return Text('$remainingBreaks of ${_selectedSlices.length} breaks left, repeating forever (run ${_repetition+1})');
      }
      else {
        return Text('$remainingBreaks of ${_selectedSlices.length} breaks left');
      }
    }
    else {
      if (_runMode == RunMode.REPEAT_FOREVER) {
        return Text('${_selectedSlices.length} breaks placed, repeat forever');
      }
      else if (_runMode == RunMode.REPEAT_ONCE) {
        return Text('${_selectedSlices.length} breaks placed, repeat once');
      }
      else {
        return Text('${_selectedSlices.length} breaks placed');
      }
    }
  }

  Widget _createCycleWidget() {
    if (_timerMode == TimerMode.RELATIVE) {
      return _createCycleWidgetForRelativeMode(_relativeProgressPresentation);
    }
    else if (_timerMode == TimerMode.ABSOLUTE) {
      return _createCycleWidgetForAbsoluteMode(_absoluteProgressPresentation);
    }
    else {
      throw Exception('unknown timerMode ' + _timerMode.toString());
    }
  }

  Widget _createCycleWidgetForRelativeMode(RelativeProgressPresentation presentation) {
    if (_isRunning() || _isAllRunsOver()) {
      var value1 = formatDuration(_getDelta()!);
      var value2 = formatDuration(_getRemaining()!);
      var value3 = formatDuration(_duration);
      if (_isAllRunsOver()) {
        value1 = formatDuration(_duration);
        value2 = formatDuration(Duration.zero);
        value3 = formatDuration(_duration);
      }

      if (presentation == RelativeProgressPresentation.REMAINING) {
        return Text(value2);
      }
      else if (presentation == RelativeProgressPresentation.PROGRESSING) {
        return Text(value1);
      }
      else if (presentation == RelativeProgressPresentation.REMAINING_PRORESSING) {
        return _createTwoRowsCircle(value1, value2);
      }
      else {
        return _createTreeRowsCircle(value1, value2, value3);
      }
    }
    else {
      return Text(formatDuration(_duration));
    }
  }


  Widget _createCycleWidgetForAbsoluteMode(AbsoluteProgressPresentation presentation) {
    if (_isRunning() || _isAllRunsOver()) {
      var value1 = formatDateTime(_startedAt!, withSeconds: true);
      var value2 = formatDateTime(DateTime.now(), withSeconds: true);
      var value3 = formatDateTime(_time, withSeconds: true);
      if (_isAllRunsOver()) {
        value1 = formatDateTime(_startedAt!, withSeconds: true);
        value2 = formatDateTime(_time, withSeconds: true);
        value3 = formatDateTime(_time, withSeconds: true);
      }

      if (presentation == AbsoluteProgressPresentation.START_CURRENT) {
        return _createTwoRowsCircle(value1, value2, smallValue1: true);
      }
      else if (presentation == AbsoluteProgressPresentation.CURRENT_END) {
        return _createTwoRowsCircle(value2, value3, smallValue2: true);
      }
      else {
        return _createTreeRowsCircle(value1, value2, value3);
      }
    }
    else {
      return Text(formatDateTime(_time));
    }
  }

  Widget _createTwoRowsCircle(String value1, String value2, {bool smallValue1 = false, bool smallValue2 = false}) {
    return Column(
      children: [
        Text(value1,
          textAlign: TextAlign.center,
          style: smallValue1 ? const TextStyle(fontSize: 10) : null,
        ),
        SizedBox(
            width: 80,
            child: Divider(thickness: 0.5, color: ColorService().getCurrentScheme().accent, height: 5)
        ),
        Text(value2,
            textAlign: TextAlign.center,
            style: smallValue2 ? const TextStyle(fontSize: 10) : null,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _createTreeRowsCircle(String value1, String value2, String value3) {
    return Column(
      children: [
        Text(
            value1,
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center
        ),
        SizedBox(
            width: 80,
            child: Divider(thickness: 0.5, color: ColorService().getCurrentScheme().accent, height: 5)
        ),
        Text(value2, textAlign: TextAlign.center),
        SizedBox(
            width: 80,
            child: Divider(thickness: 0.5, color: ColorService().getCurrentScheme().accent, height: 5)
        ),
        Text(
            value3,
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  void _changeDuration(BuildContext context) {
    final initialDuration = _duration;
    Duration? _tempSelectedDuration;
    showDurationPickerDialog(
      context: context,
      initialDuration: initialDuration,
      onChanged: (duration) => _tempSelectedDuration = duration,
    ).then((okPressed) {
      if (okPressed ?? false) {
        setState(() {
          final duration = _tempSelectedDuration ?? initialDuration;
          _updateDuration(duration, fromUser: true);
          _persistState();
        });
      }
    });
  }

  void _changeTime(BuildContext context) {
    final initialTime = TimeOfDay.fromDateTime(_deriveTime());
    showTimePicker(
      initialTime: initialTime,
      context: context,
    ).then((selectedTime) {
      if (selectedTime != null) {
        setState(() {
          final adjusted = _updateAndAdjustTime(selectedTime, fromUser: true);
          _originDuration = null;
          _originTime = null;
          _persistState();
          if (adjusted) {
            toastInfo(context, 'Clock value should be a bit more in the future');
          }
        });
      }
    });
  }

  bool _updateAndAdjustTime(TimeOfDay timeOfDay, {required bool fromUser}) {
    final now = DateTime.now();
    final nowTime = TimeOfDay.now();
    final nowMinutes = nowTime.hour * 60 + nowTime.minute;
    final selectedMinutes = timeOfDay.hour * 60 + timeOfDay.minute;
    DateTime time = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

    if (selectedMinutes < nowMinutes) {
      // next day
      time = time.add(const Duration(days: 1));
    }
    _updateTime(time, fromUser: fromUser);

    Duration duration = now.difference(_time).abs();
    bool adjusted = false;
    if (duration.inMinutes < 1) {
      duration = const Duration(minutes: 1);
      adjusted = true;
    }
    _updateDuration(duration, fromUser: fromUser);
    return adjusted;
  }

  List<int> _selectedSortedSlices() => _selectedSlices.toList()..sort();

  Duration _getDelay(int slice) => Duration(seconds: (_duration.inSeconds * slice / MAX_SLICE).round());

  List<PieChartSectionData> _createSections() {
    var slices = new List<int>.generate(MAX_SLICE, (i) => i + 1);
    double r = (MediaQuery.of(context).size.width / 2) - CENTER_RADIUS - (23 * 2);
    final sliceSeconds = _duration.inSeconds / MAX_SLICE;

    return slices.map((slice) {
      final isTouched = slice == _touchedIndex;
      final isPassed = slice < _passedIndex;
      final isInTransition = slice == _passedIndex;
      final isSelected = _selectedSlices.contains(slice);
      final isFinalSlice = slice == MAX_SLICE;
      final list = _selectedSortedSlices();
      final indexOfSelected = list.indexOf(slice) + 1;
      var radius = isTouched ? r * 1.3 : r;
      if (isInTransition) {
        final deltaSeconds = _getDelta()?.inSeconds ?? 0;
        final transitionSeconds = deltaSeconds % sliceSeconds;
        //debugPrint('transSec=$transitionSeconds / sliceSec=$sliceSeconds');
        radius = radius + (radius * (transitionSeconds / sliceSeconds * 0.1));
      }
      else if (isPassed) {
        radius = radius * 1.1;
      }

      final value = 1.0;

      return PieChartSectionData(
        color: isFinalSlice
            ? ColorService().getCurrentScheme().accent
            : (isPassed || isInTransition ? ColorService().getCurrentScheme().foreground : ColorService().getCurrentScheme().button).withOpacity(
            isSelected
                ? (isPassed ? 1 : 0.9)
                : (isPassed ? 0.7 : (isInTransition ? 0.5 : 0.4))
        ),
        value: value,
        radius: radius,
        showTitle: isTouched || isSelected || isFinalSlice || isInTransition,
        title: _showSliceTitle(slice, isInTransition, isFinalSlice),
        titleStyle:
          isFinalSlice
              ? const TextStyle(fontSize: 14)
              : isInTransition
                ? const TextStyle(fontSize: 8)
                : const TextStyle(fontSize: 10),
        titlePositionPercentageOffset: isTouched ? 0.9 : 1.23,
        badgeWidget: isSelected ? _getIconForNumber(indexOfSelected, _selectedSlices.length) : null,
      );
    }).toList();
  }

  String _showSliceTitle(int slice, bool showCurrent, bool isFinalSlice) {
    if (_timerMode == TimerMode.RELATIVE) {
      final sliceDuration = isFinalSlice ? _duration : _getDelay(slice);
      return formatDuration(
          showCurrent ? _getDelta()??sliceDuration : sliceDuration,
          withLineBreak: true,
          noSeconds: _duration.inMinutes >= 60);
    }
    else if (_timerMode == TimerMode.ABSOLUTE) {
      final nowOrStartedAt = _startedAt ?? DateTime.now();
      final delta = nowOrStartedAt.difference(_time).abs();
      final sliceDuration = Duration(seconds: delta.inSeconds * slice ~/ MAX_SLICE);
      debugPrint('nowOrStartedAt=$nowOrStartedAt delta=${delta.inMinutes} sl=$slice sliceDur=$sliceDuration');
      final sliceTime = isFinalSlice ? _time : nowOrStartedAt.add(sliceDuration);
      return formatDateTime(
          showCurrent ? DateTime.now() : sliceTime,
          withLineBreak: true,
          withSeconds: delta.inMinutes < 10);
    }
    else {
      throw Exception('unknown timerMode ' + _timerMode.toString());
    }
  }

  Icon? _getIconForNumber(int number, int count, {bool forceAsc = false}) {
    int n = number;
    if (!forceAsc && _direction == Direction.DESC && number != 0) {
      n = count + 1 - number;
    }
    switch (n) {
      case 0: return Icon(MdiIcons.numeric0BoxOutline);
      case 1: return Icon(MdiIcons.numeric1BoxOutline);
      case 2: return Icon(MdiIcons.numeric2BoxOutline);
      case 3: return Icon(MdiIcons.numeric3BoxOutline);
      case 4: return Icon(MdiIcons.numeric4BoxOutline);
      case 5: return Icon(MdiIcons.numeric5BoxOutline);
      case 6: return Icon(MdiIcons.numeric6BoxOutline);
      case 7: return Icon(MdiIcons.numeric7BoxOutline);
      case 8: return Icon(MdiIcons.numeric8BoxOutline);
      case 9: return Icon(MdiIcons.numeric9BoxOutline);
      case 10: return Icon(MdiIcons.numeric10BoxOutline);
      case 11: return Icon(MdiIcons.numeric1BoxMultipleOutline);
      case 12: return Icon(MdiIcons.numeric2BoxMultipleOutline);
      case 13: return Icon(MdiIcons.numeric3BoxMultipleOutline);
      case 14: return Icon(MdiIcons.numeric4BoxMultipleOutline);
      case 15: return Icon(MdiIcons.numeric5BoxMultipleOutline);
      case 16: return Icon(MdiIcons.numeric6BoxMultipleOutline);
      case 17: return Icon(MdiIcons.numeric7BoxMultipleOutline);
      case 18: return Icon(MdiIcons.numeric8BoxMultipleOutline);
      case 19: return Icon(MdiIcons.numeric9BoxMultipleOutline);
      case 20: return Icon(MdiIcons.numeric10BoxMultipleOutline);
    }
    return null;
  }

  bool _isRunning() => _startedAt != null;

  void _startRun(BuildContext context) {
    if (_duration.inSeconds == 0) {
      toastError(context, 'Duration might not be zero');
      return;
    }
    if (_isRunning()) {
      toastError(context, _stopRunningMessage());
      return;
    }
    if (_timerMode == TimerMode.ABSOLUTE && _isTimeElapsed()) {
      toastError(context, 'Time already reached, set a new one');
      return;
    }

    _preferenceService.remove(PreferenceService.STATE_SIGNAL_CANCELLING);
    _preferenceService.remove(PreferenceService.STATE_SIGNAL_PROCESSING);


    _startedAt = DateTime.now();
    _startTimer();
    _updateRunning();

    final startedAt = _startedAt;
    if (startedAt == null) { // should not happen
      throw Exception('_startedAt should not be null here');
    }

    _persistState();

    _askForNotification();

    if (_timerMode == TimerMode.RELATIVE) {
      setState(() {
        final time = startedAt.add(_duration);
        _updateTime(time, fromUser: false);
      });
    }
    else if (_timerMode == TimerMode.ABSOLUTE) {
      setState(() {
        final duration = startedAt.difference(_time).abs();
        _updateDuration(duration, fromUser: false);
      });
    }
    SignalService.makeSignalPattern(START,
      volume: _volume,
      neverSignalTwice: true,
      signalAlthoughCancelled: true,
      preferenceService: _preferenceService,
    );
    notify(0, 'Timer started',
        preferenceService: _preferenceService,
        notificationService: _notificationService,
        showProgress: true,
        showStartInfo: true,
        fixed: true);

    _scheduleSliceNotifications();

  }

  void _startSpinner() {
    _circleAnimationLastValue = 0;
    _circleAnimationController.value = 0;
    _circleAnimationController.repeat();
    _circleAnimationDirection = false;
  }

  void _updateDuration(Duration duration, {required bool fromUser}) {
    if (fromUser) {
      _originDuration = null;
      _hasDurationChangedForCurrentBreakDown = true;
    }
    else if (_originDuration == null) {
      _originDuration = _duration;
    }
    _duration = duration;
  }

  void _updateTime(DateTime time, {required bool fromUser}) {
    if (fromUser) {
      _originTime = null;
      _hasTimeChangedForCurrentBreakDown = true;
    }
    else if (_originTime == null) {
      _originTime = _time;
    }
    _time = time;
  }

  Future<void> _persistState() async {
    final stateAsJson = jsonEncode(this);
    debugPrint('!!!!State to persist: $stateAsJson');
    await setRunState(_preferenceService, stateAsJson);
  }

  void _scheduleSliceNotifications() {
    final list = _selectedSortedSlices();
    debugPrint('$list');
    for (int i = 0; i < list.length; i++) {
      final signal = i + 1;
      final slice = list[i];
      Function f = _signalFunction(signal);
    
      AndroidAlarmManager.oneShot(alarmClock: true, wakeup: true, allowWhileIdle: true, exact: true,
          _getDelay(slice), signal, f)
          .then((value) => debugPrint('shot $signal on $slice: $value'));
    }

    if (_isRepeating()) {
      AndroidAlarmManager.oneShot(
          alarmClock: true, wakeup: true, allowWhileIdle: true, exact: true,
          _duration, 1000, signalEndWithRepetition)
          .then((value) => debugPrint('shot end with repeat: $value'));
    }
    else {
      AndroidAlarmManager.oneShot(
          alarmClock: true, wakeup: true, allowWhileIdle: true, exact: true,
          _duration, 1000, signalEnd)
          .then((value) => debugPrint('shot end: $value'));
    }
  }

  bool _isTimeElapsed() => !truncToMinutes(_time).isAfter(truncToMinutes(DateTime.now()));

  void _stopRun(BuildContext context) {
    debugPrint('stopped');
    _stopTimer();
    _circleAnimationController.stop();

    SignalService().stopAll();
    _persistState();
    _notificationService.cancelAllNotifications();
    SignalService.makeSignalPattern(CANCEL,
        volume: _volume,
        neverSignalTwice: true,
        signalAlthoughCancelled: true,
        preferenceService: _preferenceService);
    for (int slice = 1; slice <= MAX_SLICE; slice++) {
      AndroidAlarmManager.cancel(slice);
    }
    AndroidAlarmManager.cancel(1000);
  }

  DateTime _deriveTime() => roundToHour(DateTime.now().add(_duration));

  Map<String, dynamic> toJson() {

    return {
    'duration' : _duration.inSeconds,
    'time': _time.millisecondsSinceEpoch,
    'originDuration' : _originDuration?.inSeconds,
    'originTime': _originTime?.millisecondsSinceEpoch,
    'hasDurationChanged': _hasDurationChangedForCurrentBreakDown,
    'hasTimeChanged': _hasTimeChangedForCurrentBreakDown,
    'timerMode': _timerMode.index,
    'direction': _direction.index,
    'startedAt': _startedAt?.millisecondsSinceEpoch,
    'selectedSlices': _selectedSortedSlicesToString(),
    'selectedBreakDown': _selectedBreakDown?.id,
    'pinnedBreakDownId': _pinnedBreakDownId,
    'runMode': _runMode.index,
    'repetition': _repetition,
  };
  }

  String _selectedSortedSlicesToString() => _selectedSortedSlices().join(',');

  void _setStateFromJson(Map<String, dynamic> jsonMap) {
    _duration = Duration(seconds: jsonMap['duration']);
    _time = DateTime.fromMillisecondsSinceEpoch(jsonMap['time']);

    if (jsonMap['originDuration'] != null) {
      _originDuration = Duration(seconds: jsonMap['originDuration']);
    }
    if (jsonMap['originTime'] != null) {
      _originTime = DateTime.fromMillisecondsSinceEpoch(jsonMap['originTime']);
    }

    if (jsonMap['hasDurationChanged'] != null) {
      _hasDurationChangedForCurrentBreakDown = jsonMap['hasDurationChanged'];
    }
    if (jsonMap['hasTimeChanged'] != null) {
      _hasTimeChangedForCurrentBreakDown = jsonMap['hasTimeChanged'];
    }

    _timerMode = TimerMode.values.elementAt(jsonMap['timerMode']);
    _direction = Direction.values.elementAt(jsonMap['direction']);
    if (jsonMap['startedAt'] != null) {
      _startedAt = DateTime.fromMillisecondsSinceEpoch(jsonMap['startedAt']);
    }

    _selectedSlices.clear();
    jsonMap['selectedSlices'].toString().split(',')
        .map((e) => int.tryParse(e))
        .whereType<int>()
        .forEach((e) => _selectedSlices.add(e));

    _pinnedBreakDownId = jsonMap['pinnedBreakDownId'];

    if (jsonMap['runMode'] != null) {
      _runMode = RunMode.values.elementAt(jsonMap['runMode']);
    }
    if (jsonMap['repetition'] != null) {
      _repetition = jsonMap['repetition'];
    }
  }

  String _getSignalStringForNumber(int signal) {
    switch (signal) {
      case 1: return SignalService.signalPatternToString(SIG_1);
      case 2: return SignalService.signalPatternToString(SIG_2);
      case 3: return SignalService.signalPatternToString(SIG_3);
      case 4: return SignalService.signalPatternToString(SIG_4);
      case 5: return SignalService.signalPatternToString(SIG_5);
      case 6: return SignalService.signalPatternToString(SIG_6);
      case 7: return SignalService.signalPatternToString(SIG_7);
      case 8: return SignalService.signalPatternToString(SIG_8);
      case 9: return SignalService.signalPatternToString(SIG_9);
      case 10: return SignalService.signalPatternToString(SIG_10);
      case 11: return SignalService.signalPatternToString(SIG_11);
      case 12: return SignalService.signalPatternToString(SIG_12);
      case 13: return SignalService.signalPatternToString(SIG_13);
      case 14: return SignalService.signalPatternToString(SIG_14);
      case 15: return SignalService.signalPatternToString(SIG_15);
      case 16: return SignalService.signalPatternToString(SIG_16);
      case 17: return SignalService.signalPatternToString(SIG_17);
      case 18: return SignalService.signalPatternToString(SIG_18);
      case 19: return SignalService.signalPatternToString(SIG_19);
      case 20: return SignalService.signalPatternToString(SIG_20);
      case 100: return SignalService.signalPatternToString(SIG_END);
    }
    throw Exception('unknown signal $signal');
  }

  String _getSignalForNumber(int signal) {
    switch (signal) {
      case 1: return SIG_1;
      case 2: return SIG_2;
      case 3: return SIG_3;
      case 4: return SIG_4;
      case 5: return SIG_5;
      case 6: return SIG_6;
      case 7: return SIG_7;
      case 8: return SIG_8;
      case 9: return SIG_9;
      case 10: return SIG_10;
      case 11: return SIG_11;
      case 12: return SIG_12;
      case 13: return SIG_13;
      case 14: return SIG_14;
      case 15: return SIG_15;
      case 16: return SIG_16;
      case 17: return SIG_17;
      case 18: return SIG_18;
      case 19: return SIG_19;
      case 20: return SIG_20;
      case 100: return SIG_END;
    }
    throw Exception('unknown signal $signal');
  }

  bool _isPinnedBreakDown() => _selectedBreakDown != null && _selectedBreakDown?.id == _pinnedBreakDownId;

  bool _isRepeating() => _runMode == RunMode.REPEAT_FOREVER || (_runMode == RunMode.REPEAT_ONCE && _repetition == 0);

  String _stopRunningMessage() {
    if (_isAllRunsOver()) {
      return 'Reset the timer first';
    }
    else {
      return 'Stop running first';
    }
  }

}

