import 'dart:async';
import 'dart:collection';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bdt/service/LocalNotificationService.dart';
import 'package:bdt/service/PreferenceService.dart';
import 'package:bdt/service/SignalService.dart';
import 'package:bdt/ui/BDTApp.dart';
import 'package:bdt/ui/HoldOnButton.dart';
import 'package:bdt/ui/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../model/BreakDown.dart';
import '../service/LocalNotificationService.dart';
import '../service/PreferenceService.dart';
import '../util/dates.dart';
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

  late List<bool> _timerModeSelection;
  TimerMode _timerMode = TimerMode.RELATIVE;
  Direction _direction = Direction.ASC;

  BreakDown? _selectedBreakDown = null;

  final _notificationService = LocalNotificationService();
  final _preferenceService = PreferenceService();
  Timer? _runTimer;
  DateTime? _startedAt;



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
    await notify(100, "Timer finished", false);
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
    await notify(signal, "Break $signal reached", true);
  }

  static Future<void> notify(int id, String msg, bool keepAsProgress,
      {PreferenceService? preferenceService, LocalNotificationService? notificationService}) async {
    if (await canNotify(preferenceService ?? PreferenceService()) != true) {
      debugPrint("notification disabled");
   //   return; //TODO impl it
    }
    final _notificationService = notificationService ?? LocalNotificationService();
    if (notificationService != null) {
      await _notificationService.init();
    }
    _notificationService.cancelAllNotifications();
    _notificationService.showNotification("", id, "BDT", msg, "bdt_signals", keepAsProgress, "");
  }

  static Future<bool> canNotify(PreferenceService preferenceService) async {
    return await preferenceService.getBool("CAN_NOTIFY") == true;
  }

  @override
  void initState() {
    super.initState();
    _time = _deriveTime();
    _notificationService.init();
    _timerModeSelection = List.generate(TimerMode.values.length, (index) => index == _timerMode.index);

    Timer.periodic(Duration(minutes: 1), (_) {
      setState((){
        debugPrint("refresh ui values");
      });
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
              onPressed: () {},
              icon: Icon(Icons.volume_up_rounded)),
          IconButton(
              onPressed: () {
                if (_isRunning()) {
                  toastError(context, "Stop running first");
                  return;
                }
                setState(() {
                  _selectedSlices.clear();
                  _selectedBreakDown = null;
                });
              },
              icon: Icon(MdiIcons.restart)),
          IconButton(
              onPressed: () {
                if (_isRunning()) {
                  toastError(context, "Stop running first");
                  return;
                }
                setState(() => _direction = (_direction == Direction.ASC ? Direction.DESC : Direction.ASC));
              },
              icon: Icon(Icons.sync_alt)),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: DropdownButtonFormField<BreakDown?>(
              onTap: () => FocusScope.of(context).unfocus(),
              value: _selectedBreakDown,
              hint: Text("Break downs"),
              iconEnabledColor: BUTTON_COLOR,
              icon: Icon(Icons.av_timer),
              isExpanded: true,
              onChanged:  _isRunning() ? null : (value) {
                setState(() {
                  _selectedBreakDown = value;
                  _selectedSlices.clear();
                  if (value != null) {
                    _selectedSlices.addAll(value.slices.toList());
                  }
                });
              },
              items: predefinedBreakDowns.map((BreakDown breakDown) {
                return DropdownMenuItem(
                  value: breakDown,
                  child: Text(breakDown.name),
                );
              }).toList(),
            ),
          ),
          ToggleButtons(
            children: [
              Icon(Icons.timer_outlined, color: _timerMode == TimerMode.RELATIVE ? ACCENT_COLOR : BUTTON_COLOR),
              Icon(MdiIcons.alarm, color: _timerMode == TimerMode.ABSOLUTE ? ACCENT_COLOR : BUTTON_COLOR),
            ],
            isSelected: _timerModeSelection,
            onPressed: (int index) {
              setState(() {
                _timerModeSelection[_timerMode.index] = false;
                _timerModeSelection[index] = true;
                _timerMode = TimerMode.values.elementAt(index);
              });
            },
            renderBorder: true,
            borderWidth: 1.5,
            borderRadius: BorderRadius.all(Radius.circular(29)),
            borderColor: BUTTON_COLOR,
            color: BUTTON_COLOR,
            selectedBorderColor: ACCENT_COLOR,
            highlightColor: FOREGROUND_COLOR,
            selectedColor: ACCENT_COLOR,
          ),
          AspectRatio(
            aspectRatio: 1,
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
                Visibility(
                  visible: true,
                  child: Center(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: _createCycleWidget(),
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
                ),
              ],
            ),
          ),
          Center(
            child: _createStatsLine()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: BUTTON_COLOR,
        splashColor: FOREGROUND_COLOR,
        foregroundColor: ACCENT_COLOR,
        child: Icon(_isOver() ? MdiIcons.restart : _isRunning() ? Icons.stop : Icons.play_arrow),
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
            if (_isOver()) {
              toastError(context, "Timer time still reached, set it new");
            }
            else {
              _startRun(context);
            }
          }
        },
      ),
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
      return Text("$remainingBreaks breaks left");
    }
    else {
      return Text("${_selectedSlices.length} breaks selected");
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
          Text("${formatDuration(_duration)}"),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ACCENT_COLOR, height: 5)
          ),
          Text("${formatDuration(Duration.zero)}"),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
    else if (_isRunning()) {
      return Column(
        children: [
          Text("${formatDuration(_getDelta()!)}"),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ACCENT_COLOR, height: 5)
          ),
          Text("${formatDuration(_getRemaining()!)}"),
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
          Text(formatToDateTime(_time, withSeconds: true)),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ACCENT_COLOR, height: 5)
          ),
          Text(formatToDateTime(_startedAt!, withSeconds: true)),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
    else if (_isRunning()) {
      return Column(
        children: [
          Text(formatToDateTime(DateTime.now(), withSeconds: true)),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ACCENT_COLOR, height: 5)
          ),
          Text(formatToDateTime(_startedAt!, withSeconds: true)),
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
            toastInfo(context, "Clock value should be more in the future");
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
    double r = (MediaQuery.of(context).size.width / 2) - CENTER_RADIUS - (20 * 2);
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
        showTitle: isTouched || isSelected || isFinalSlice,
        title: _showSliceTitle(slice),
        titleStyle: isFinalSlice ? TextStyle(fontSize: 14) : TextStyle(fontSize: 10),
        titlePositionPercentageOffset: isTouched ? 0.9 : 1.2,
        badgeWidget: isSelected ? _getIconForNumber(indexOfSelected, _selectedSlices.length) : null,
      );
    }).toList();
  }

  String _showSliceTitle(int slice) {
    if (_timerMode == TimerMode.RELATIVE) {
      final sliceDuration = _getDelay(slice);
      return formatDuration(sliceDuration, withLineBreak: true);
    }
    else if (_timerMode == TimerMode.ABSOLUTE) {
      final nowOrStartedAt = _startedAt ?? DateTime.now();
      final delta = nowOrStartedAt.difference(_time).abs();
      final sliceDuration = Duration(seconds: (delta.inSeconds * slice / MAX_SLICE).round());
      debugPrint("nowOrStartedAt=$nowOrStartedAt delta=${delta.inMinutes} sl=$slice sliceDur=$sliceDuration");
      final sliceTime = roundToMinute(nowOrStartedAt.add(sliceDuration));
      return formatToDateTime(sliceTime, withLineBreak: true);
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

    _startTimer();

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

    SignalService.makeSignalPattern(START);
    notify(0, "Timer started", true, preferenceService: _preferenceService, notificationService: _notificationService);

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

    _updateRunning();

  }

  void _stopRun(BuildContext context) {
    debugPrint("stopped");
    _stopTimer();
    _notificationService.cancelAllNotifications();
    SignalService.makeSignalPattern(CANCEL);
    for (int slice = 1; slice <= MAX_SLICE; slice++) {
      AndroidAlarmManager.cancel(slice);
    }
    AndroidAlarmManager.cancel(1000);
  }

  DateTime _deriveTime() => roundToHour(DateTime.now().add(_duration));

}

