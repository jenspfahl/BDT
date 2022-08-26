import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bdt/service/LocalNotificationService.dart';
import 'package:bdt/service/PreferenceService.dart';
import 'package:bdt/service/SignalService.dart';
import 'package:bdt/ui/BDTApp.dart';
import 'package:bdt/ui/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:slider_button/slider_button.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

import '../model/BreakDown.dart';
import '../service/LocalNotificationService.dart';
import '../service/PreferenceService.dart';
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

class BDTScaffoldState extends State<BDTScaffold> {

  final MAX_SLICE = 60;
  final CENTER_RADIUS = 60.0;

  int _touchedIndex = -1;
  int _passedIndex = -1;

  Duration _duration = kReleaseMode ? Duration(minutes: 60): Duration(seconds: 60);
  late DateTime _time;

  final _selectedSlices = HashSet<int>();

  TimerMode _timerMode = TimerMode.RELATIVE;
  Direction _direction = Direction.ASC;

  BreakDown? _selectedBreakDown = null;

  final _notificationService = LocalNotificationService();
  final _preferenceService = PreferenceService();
  Timer? _runTimer;
  DateTime? _startedAt;
  int _volume = MAX_VOLUME;
  RingerModeStatus _ringerStatus = RingerModeStatus.unknown;



  static Future<void> signal1() async {
    debugPrint("sig 1");

    await notifySignal(1);
    await SignalService.makeSignalPattern(SIG_1);
  }

  static Future<void> signal2() async {
    debugPrint("sig 2");

    await notifySignal(2);
    await SignalService.makeSignalPattern(SIG_2);
  }

  static Future<void> signal3() async {
    debugPrint("sig 3");

    await notifySignal(3);
    await SignalService.makeSignalPattern(SIG_3);
  }

  static Future<void> signal4() async {
    debugPrint("sig 4");

    await notifySignal(4);
    await SignalService.makeSignalPattern(SIG_4);
  }

  static Future<void> signal5() async {
    debugPrint("sig 5");

    await notifySignal(5);
    await SignalService.makeSignalPattern(SIG_5);
  }

  static Future<void> signal6() async {
    debugPrint("sig 6");

    await notifySignal(6);
    await SignalService.makeSignalPattern(SIG_6);
  }

  static Future<void> signal7() async {
    debugPrint("sig 7");

    await notifySignal(7);
    await SignalService.makeSignalPattern(SIG_7);
  }

  static Future<void> signal8() async {
    debugPrint("sig 8");

    await notifySignal(8);
    await SignalService.makeSignalPattern(SIG_8);
  }

  static Future<void> signal9() async {
    debugPrint("sig 9");

    await notifySignal(9);
    await SignalService.makeSignalPattern(SIG_9);
  }

  static Future<void> signal10() async {
    debugPrint("sig 10");

    await notifySignal(10);
    await SignalService.makeSignalPattern(SIG_10);
  }

  static Future<void> signalEnd() async {
    debugPrint("sig end");
    await notify(100, "Timer finished", showBreakInfo: true, showProgress: true);
    await SignalService.makeSignalPattern(END);
  }

  Function _signalFunction(int signal) {
    int s = signal;
    if (_direction == Direction.DESC) {
      s = _selectedSlices.length + 1 - signal;
    }
    debugPrint("signal=$signal s=$s");
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
    }
    throw Exception("unknown signal $signal");
  }

  static Future<void> notifySignal(int signal) async {
    final prefService = PreferenceService();
    final breaksCount = await getBreaksCount(prefService);

    await notify(signal, "Break $signal of $breaksCount reached",
        showProgress: true, showBreakInfo: true, fixed: true);
  }

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
      debugPrint("notification disabled");
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
       // message = "$msg after ${formatDuration(duration)} at ${formatToDateTime(now)}";
        message = "$msg after ${formatDuration(duration)}";
      }
    }
    else if (showStartInfo) {
      final breaksCount = await getBreaksCount(prefService);
      message = "$msg with $breaksCount breaks";
    }
    _notificationService.showNotification("", id, "BDT", message, "bdt_signals", 
        showProgress, fixed, progress, "");
  }

  @override
  void initState() {
    super.initState();
    _time = _deriveTime();
    _notificationService.init();
    _updateBreakOrder();

    getVolume(_preferenceService).then((value) {
      if (value != null) {
        setState(() => _volume = value);
      }
    });

    Timer.periodic(Duration(seconds: 15), (_) {
      setState((){
        SoundMode.ringerModeStatus.then((value) => _ringerStatus = value);
        debugPrint("refresh ui values");
      });
    });
  }

  void _updateBreakOrder() {
    _preferenceService.getBool(PreferenceService.PREF_BREAK_ORDER_DESCENDING)
        .then((isDescending) {
          if (isDescending == true) {
            _direction = Direction.DESC;
          }
          else {
            _direction = Direction.ASC;
          }
        });
  }

  _startTimer() {
    _startedAt = DateTime.now();
    _runTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateRunning();
      debugPrint(".. timer refresh #${_runTimer?.tick} ..");
      if (_isOver()) {
        timer.cancel();
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
      debugPrint("delta=$delta, ratio = $ratio");
      setState(() {
        _passedIndex = (MAX_SLICE * ratio).floor() + 1;
        // update all
      });
    }
  }

  bool _isOver() {
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
      _passedIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BDT"),
        actions: [
          IconButton(
              onPressed: () async {
                _ringerStatus = await SoundMode.ringerModeStatus;
                setState((){});
                if (_isDeviceMuted()) {
                  toastInfo(context, "Device is muted. Unmute first to set volume.");
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
                  _volume = volume.round();
                  setVolume(_preferenceService, _volume);
                  setState(() {}); // update
                }
                SignalService.setSignalVolume(_volume);
              },
              icon: _isDeviceMuted() ? Icon(Icons.volume_off) : createVolumeIcon(_volume)),
          IconButton(
              onPressed: () {
                Navigator.push(super.context, MaterialPageRoute(builder: (context) => SettingsScreen()))
                    .then((value) => setState(() => _updateBreakOrder()));
              },
              icon: Icon(Icons.settings)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: IconButton(
                      onPressed: () => _moveBreakDownSelectionToNext(),
                      color: _isRunning() || _isBreakDownSelectionAtStart() ? Colors.grey[700] : BUTTON_COLOR,
                      icon: Icon(Icons.arrow_back_ios),
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
                      focusColor: ACCENT_COLOR,
                      onTap: () => FocusScope.of(context).unfocus(),
                      value: _selectedBreakDown,
                      hint: Text("Break downs"),
                      iconEnabledColor: BUTTON_COLOR,
                      icon: Icon(Icons.av_timer),
                      isExpanded: true,
                      onChanged:  _isRunning() ? null : (value) {
                        _updateSelectedSlices(value);
                      },
                      items: predefinedBreakDowns.map((BreakDown breakDown) {
                        return DropdownMenuItem(
                          value: breakDown,
                          child: Text(breakDown.name),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Flexible(child: IconButton(
                  color: _isRunning() || _isBreakDownSelectionAtEnd() ? Colors.grey[700] : BUTTON_COLOR,
                  onPressed: () => _moveBreakDownSelectionToPrevious(),
                  icon: Icon(Icons.arrow_forward_ios),
                )),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: _switchTimerMode,
            child: CupertinoSlidingSegmentedControl<TimerMode>(
              backgroundColor: Colors.black,
              thumbColor: BUTTON_COLOR,
              padding: EdgeInsets.all(8),
              children: <TimerMode, Widget> {
                TimerMode.RELATIVE: Icon(Icons.timer_outlined, color: _timerMode == TimerMode.RELATIVE ? ACCENT_COLOR : BUTTON_COLOR),
                TimerMode.ABSOLUTE: Icon(Icons.alarm, color: _timerMode == TimerMode.ABSOLUTE ? ACCENT_COLOR : BUTTON_COLOR),
              },
              onValueChanged: (value) {
                if (value != null) {
                  setState(() => _timerMode = value);
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
                              setState(() {
                                if (_isRunning()) {
                                  return;
                                }
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  _touchedIndex = -1;
                                  return;
                                }
                                _touchedIndex =
                                    (pieTouchResponse.touchedSection!.touchedSectionIndex + 1) % MAX_SLICE;
                                debugPrint("_touchedIndex=$_touchedIndex");
                                if (_touchedIndex != 0) {
                                  if (_selectedSlices.contains(_touchedIndex)) {
                                    _selectedSlices.remove(_touchedIndex);
                                  }
                                  else {
                                    if (_selectedSlices.length < 10) {
                                      _selectedSlices.add(_touchedIndex);
                                    }
                                    else {
                                      toastError(context, "max 10 breaks allowed");
                                    }
                                  }
                                }
                                debugPrint("_selected=$_selectedSlices");

                              });
                            }),
                        borderData: FlBorderData(
                            show: false
                        ),
                        sectionsSpace: 1,
                        centerSpaceRadius: CENTER_RADIUS,
                        sections: _createSections(),
                        startDegreeOffset: 270 + 2.5
                    ),
                    swapAnimationDuration: Duration(milliseconds: 75),
                  ),
                  Center(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: SizedBox(
                        width: CENTER_RADIUS * 1.5,
                        height: CENTER_RADIUS * 1.5,
                        child: Center(child: _createCycleWidget())),
                      onTap: () {
                        if (!_isRunning()) {
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
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                      color: BUTTON_COLOR,
                      onPressed: () {
                        if (_isRunning()) {
                          toastError(context, "Stop running first");
                          return;
                        }
                        if (_selectedSlices.isEmpty) {
                          toastInfo(context, "No breaks to reset");
                        }
                        else {
                          setState(() {
                            _selectedSlices.clear();
                            _selectedBreakDown = null;
                          });
                        }
                      },
                      icon: Icon(MdiIcons.restart)),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      color: BUTTON_COLOR,
                      onPressed: () {
                        if (_isRunning()) {
                          toastError(context, "Stop running first");
                          return;
                        }
                        setState(() {
                          _direction = (_direction == Direction.ASC ? Direction.DESC : Direction.ASC);
                          toastInfo(context, "Break order switched to ${_direction == Direction.ASC ? "ascending" : "descending"}");
                        });
                      },
                      icon: Icon(Icons.swap_vert)),
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
      floatingActionButton: _isRunning() && !_isOver()
          ? _createSwipeToStopButton(context)
          : _createStartButton(context),
    );
  }

  bool _isDeviceMuted() => _ringerStatus == RingerModeStatus.silent || _ringerStatus == RingerModeStatus.vibrate;

  void _switchTimerMode(DragEndDetails details) {
    // Swiping in right direction.
    if (details.velocity.pixelsPerSecond.dx > 0) {
      setState(() => _timerMode = TimerMode.RELATIVE);
    }

    // Swiping in left direction.
    if (details.velocity.pixelsPerSecond.dx < 0) {
      setState(() => _timerMode = TimerMode.ABSOLUTE);
    }
  }

  bool _isBreakDownSelectionAtStart() {
    if (predefinedBreakDowns.isNotEmpty) {
      var currIndex = _selectedBreakDown == null ? -1 : predefinedBreakDowns
          .indexOf(_selectedBreakDown!);

      return currIndex <= 0;
    }
    return false;
  }

  bool _isBreakDownSelectionAtEnd() {
    if (predefinedBreakDowns.isNotEmpty) {
      var currIndex = _selectedBreakDown == null ? -1 : predefinedBreakDowns
          .indexOf(_selectedBreakDown!);

      return currIndex == predefinedBreakDowns.length - 1;
    }
    return false;
  }

  void _moveBreakDownSelectionToPrevious() {
    if (!_isRunning() && predefinedBreakDowns.isNotEmpty) {
      var currIndex = _selectedBreakDown == null ? -1 : predefinedBreakDowns
          .indexOf(_selectedBreakDown!);

      if (currIndex != -1) {
        currIndex = min(currIndex + 1, predefinedBreakDowns.length - 1);
      }
      else {
        currIndex = 0;
      }
      _updateSelectedSlices(predefinedBreakDowns[currIndex]);
    }
  }

  void _moveBreakDownSelectionToNext() {
    if (!_isRunning() && predefinedBreakDowns.isNotEmpty) {
      var currIndex = _selectedBreakDown == null ? -1 : predefinedBreakDowns
          .indexOf(_selectedBreakDown!);

      if (currIndex != -1) {
        currIndex = max(currIndex - 1, 0);
      }
      _updateSelectedSlices(predefinedBreakDowns[currIndex]);
    }
  }

  void _updateSelectedSlices(BreakDown? value) {
    setState(() {
      _selectedBreakDown = value;
      _selectedSlices.clear();
      if (value != null) {
        _selectedSlices.addAll(value.slices.toList());
      }
    });
  }

  Widget _createSwipeToStopButton(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FloatingActionButtonThemeData floatingActionButtonTheme = theme.floatingActionButtonTheme;
    return SliderButton(
      action: () {
        _stopRun(context);
      },
      backgroundColor: BUTTON_COLOR,
      baseColor: PRIMARY_COLOR,
      highlightedColor: ACCENT_COLOR,
      height: 48,
      width: 200,
      buttonSize: 48,
      shimmer: false,
      dismissThresholds: 0.99,
      label: Text("➡️  Swipe to Stop",
          style: TextStyle(letterSpacing: 0.7, fontWeight: FontWeight.w500, color: ACCENT_COLOR)),
      icon: Icon(Icons.stop, color: BUTTON_COLOR),
    );
  }

  Widget _createStartButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: BUTTON_COLOR,
      splashColor: FOREGROUND_COLOR,
      foregroundColor: ACCENT_COLOR,
      icon: Icon(_isOver() ? MdiIcons.restart : _isRunning() ? Icons.stop : Icons.play_arrow),
      label: Text(_isOver() ? "Reset" : _isRunning() ? "Stop" : "Start"),
      onPressed: () {
        if (_isRunning()) {
          if (_isOver()) {
            _stopRun(context);
          }
          else {
            showConfirmationDialog(
              context,
              "Stop run",
              "Really want to stop the run before it is finished?",
              icon: const Icon(MdiIcons.stopCircle),
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
    );
  }

  Text _createStatsLine() {
    if (_isOver()) {
      return Text("Timer finished");
    }
    else if (_isRunning()) {
      final remainingBreaks = _selectedSlices
          .where((index) => index >= _passedIndex)
          .toList()
          .length;
      return Text("$remainingBreaks of ${_selectedSlices.length} breaks left");
    }
    else {
      return Text("${_selectedSlices.length} breaks placed");
    }
  }

  Widget _createCycleWidget() {
    if (_timerMode == TimerMode.RELATIVE) {
      return _createCycleWidgetForRelativeMode();
    }
    else if (_timerMode == TimerMode.ABSOLUTE) {
      return _createCycleWidgetForAbsoluteMode();
    }
    else {
      throw Exception("unknown timerMode " + _timerMode.toString());
    }
  }

  Widget _createCycleWidgetForRelativeMode() {
    if (_isOver()) {
      return Column(
        children: [
          Text("${formatDuration(_duration)}",
            style: TextStyle(fontSize: 10)),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ACCENT_COLOR, height: 5)
          ),
          Text("${formatDuration(Duration.zero)}"),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ACCENT_COLOR, height: 5)
          ),
          Text("${formatDuration(_duration)}",
              style: TextStyle(fontSize: 8)),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
    else if (_isRunning()) {
      return Column(
        children: [
          Text("${formatDuration(_getDelta()!)}",
            style: TextStyle(fontSize: 10)),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ACCENT_COLOR, height: 5)
          ),
          Text("${formatDuration(_getRemaining()!)}"),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ACCENT_COLOR, height: 5)
          ),
          Text("${formatDuration(_duration)}",
              style: TextStyle(fontSize: 8)),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
    else {
      return Text(formatDuration(_duration));
    }
  }


  Widget _createCycleWidgetForAbsoluteMode() {
    if (_isOver()) {
      return Column(
        children: [
          Text(
            formatToDateTime(_startedAt!, withSeconds: true),
            style: TextStyle(fontSize: 8),
          ),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ACCENT_COLOR, height: 5)
          ),
          Text(formatToDateTime(_time, withSeconds: true)),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ACCENT_COLOR, height: 5)
          ),
          Text(
            formatToDateTime(_time, withSeconds: true),
            style: TextStyle(fontSize: 8),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
    else if (_isRunning()) {
      return Column(
        children: [
          Text(
            formatToDateTime(_startedAt!, withSeconds: true),
            style: TextStyle(fontSize: 8),
          ),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ACCENT_COLOR, height: 5)
          ),
          Text(formatToDateTime(DateTime.now(), withSeconds: true)),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ACCENT_COLOR, height: 5)
          ),
          Text(
            formatToDateTime(_time, withSeconds: true),
            style: TextStyle(fontSize: 8),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
    else {
      return Text(formatToDateTime(_time));
    }
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
        setState(() => _duration = _tempSelectedDuration ?? initialDuration);
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
          final now = DateTime.now();
          final nowTime = TimeOfDay.now();
          final nowMinutes = nowTime.hour * 60 + nowTime.minute;
          final selectedMinutes = selectedTime.hour * 60 + selectedTime.minute;
          if (selectedMinutes < nowMinutes) {
            // next day
            _time = truncToDate(now).add(Duration(days: 1)).add(Duration(minutes: selectedMinutes));
          }
          else {
            _time = truncToDate(now).add(Duration(minutes: selectedMinutes));
          }
          _duration = now.difference(_time).abs();
          if (_duration.inMinutes < 1) {
            toastInfo(context, "Clock value should be a bit more in the future");
            _duration = Duration(minutes: 1);
          }
        });
      }
    });
  }

  List<int> _selectedList() {
    final list = _selectedSlices.toList()..sort();
    return list;
  }

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
      final list = _selectedList();
      final indexOfSelected = list.indexOf(slice) + 1;
      var radius = isTouched ? r * 1.3 : r;
      if (isInTransition) {
        final deltaSeconds = _getDelta()?.inSeconds ?? 0;
        final transitionSeconds = deltaSeconds % sliceSeconds;
        debugPrint("tranSec=$transitionSeconds / sliceSec=$sliceSeconds");
        radius = radius + (radius * (transitionSeconds / sliceSeconds * 0.1));
      }
      else if (isPassed) {
        radius = radius * 1.1;
      }

      final value = 1.0;

      return PieChartSectionData(
        color: isFinalSlice
            ? ACCENT_COLOR
            : (isPassed || isInTransition ? FOREGROUND_COLOR : BUTTON_COLOR).withOpacity(
            isSelected
                ? (isPassed ? 1 : 0.9)
                : (isPassed ? 0.7 : (isInTransition ? 0.5 : 0.4))
        ),
        value: value,
        radius: radius,
        showTitle: isTouched || isSelected || isFinalSlice || isInTransition,
        title: _showSliceTitle(slice, isInTransition),
        titleStyle:
          isFinalSlice
              ? TextStyle(fontSize: 14)
              : isInTransition
                ? TextStyle(fontSize: 8)
                : TextStyle(fontSize: 10),
        titlePositionPercentageOffset: isTouched ? 0.9 : isFinalSlice ? 1.35 : 1.25,
        badgeWidget: isSelected ? _getIconForNumber(indexOfSelected, _selectedSlices.length) : null,
      );
    }).toList();
  }

  String _showSliceTitle(int slice, bool showCurrent) {
    if (_timerMode == TimerMode.RELATIVE) {
      final sliceDuration = _getDelay(slice);
      return formatDuration(
          showCurrent ? _getDelta()??sliceDuration : sliceDuration,
          withLineBreak: true);
    }
    else if (_timerMode == TimerMode.ABSOLUTE) {
      final nowOrStartedAt = _startedAt ?? DateTime.now();
      final delta = nowOrStartedAt.difference(_time).abs();
      final sliceDuration = Duration(seconds: (delta.inSeconds * slice / MAX_SLICE).round());
      debugPrint("nowOrStartedAt=$nowOrStartedAt delta=${delta.inMinutes} sl=$slice sliceDur=$sliceDuration");
      final sliceTime = roundToMinute(nowOrStartedAt.add(sliceDuration));
      return formatToDateTime(
          showCurrent ? DateTime.now() : sliceTime,
          withLineBreak: true);
    }
    else {
      throw Exception("unknown timerMode " + _timerMode.toString());
    }
  }

  Widget? _getIconForNumber(int number, int count) {
    int n = number;
    if (_direction == Direction.DESC && number != 0) {
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
    }
    return null;
  }

  bool _isRunning() => _startedAt != null;

  void _startRun(BuildContext context) {
    if (_duration.inSeconds == 0) {
      toastError(context, "Duration might not be zero");
      return;
    }
    if (_isRunning()) {
      toastError(context, "Stop running first");
      return;
    }
    if (_selectedSlices.isEmpty) {
      toastError(context, "No breaks selected");
      return;
    }
    if (_timerMode == TimerMode.ABSOLUTE && !truncToMinutes(_time).isAfter(truncToMinutes(DateTime.now()))) {
      toastError(context, "Time already reached, set a new one");
      return;
    }

    _startTimer();
    _updateRunning();

    final startedAt = _startedAt;
    if (startedAt == null) {
      return;
    }
    if (_timerMode == TimerMode.RELATIVE) {
      setState(() => _time = startedAt.add(_duration));
    }
    else if (_timerMode == TimerMode.ABSOLUTE) {
      setState(() => _duration = startedAt.difference(_time).abs());
    }
    SignalService.makeSignalPattern(START,
        volume: _volume, preferenceService: _preferenceService);
    notify(0, "Timer started",
        preferenceService: _preferenceService,
        notificationService: _notificationService,
        showProgress: true,
        showStartInfo: true,
        fixed: true);

    final list = _selectedList();
    debugPrint("$list");
    for (int i=0; i < list.length; i++) {
      final signal = i + 1;
      final slice = list[i];
      Function f = _signalFunction(signal);
      AndroidAlarmManager.oneShot(alarmClock: true, wakeup: true, allowWhileIdle: true, exact: true,
          _getDelay(slice), signal, f)
          .then((value) => debugPrint("shot $signal on $slice: $value"));
    }

    AndroidAlarmManager.oneShot(alarmClock: true, wakeup: true, allowWhileIdle: true, exact: true,
        _getDelay(MAX_SLICE), 1000, signalEnd)
        .then((value) => debugPrint("shot end: $value"));

  }

  void _stopRun(BuildContext context) {
    debugPrint("stopped");
    _stopTimer();
    _notificationService.cancelAllNotifications();
    SignalService.makeSignalPattern(CANCEL,
        volume: _volume, preferenceService: _preferenceService);
    for (int slice = 1; slice <= MAX_SLICE; slice++) {
      AndroidAlarmManager.cancel(slice);
    }
    AndroidAlarmManager.cancel(1000);
  }

  DateTime _deriveTime() => roundToHour(DateTime.now().add(_duration));

}

