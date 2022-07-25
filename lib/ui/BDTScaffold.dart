import 'dart:async';
import 'dart:collection';

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

import '../service/LocalNotificationService.dart';
import '../service/PreferenceService.dart';


class BDTScaffold extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return BDTScaffoldState();
  }
}

class BDTScaffoldState extends State<BDTScaffold> {

  final MAX_SLICE = 60;
  final CENTER_RADIUS = 60.0;

  int _touchedIndex = -1;
  int _passedIndex = -1;
  final _selected = HashSet<int>();

  final _notificationService = LocalNotificationService();
  final _preferenceService = PreferenceService();
  Timer? _timer;
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
    await notify(100, "END", false);
    await SignalService.makeSignalPattern(END);
  }

  static Function signalFunction(int signal) {
    switch (signal) {
      case 1: return signal1;
      case 2: return signal2;
      case 3: return signal3;
      case 4: return signal4;
      case 5: return signal5;
      case 6: return signal6;
      case 7: return signal8;
      case 8: return signal8;
      case 9: return signal9;
      case 10: return signal10;
    }
    throw Exception("unknown signal $signal");
  }

  static Future<void> notifySignal(int signal) async {
    await notify(signal, "Signal $signal", true);
  }

  static Future<void> notify(int id, String msg, bool keepAsProgress,
      {PreferenceService? preferenceService, LocalNotificationService? notificationService}) async {
    if (await canNotify(preferenceService ?? PreferenceService()) != true) {
      debugPrint("notification disabled");
   //   return;
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
    _notificationService.init();
  }

  _startTimer() {
    _startedAt = DateTime.now();
    _timer = Timer.periodic(kReleaseMode ? Duration(seconds: 10) : Duration(seconds: 10), (timer) {
      _updateRunning();
      debugPrint(".. timer refresh #${_timer?.tick} ..");
    });
  }

  void _updateRunning() {
    final delta = _getDelta();
    if (delta != null) {
      final passedIndex = kReleaseMode ? delta.inMinutes : delta.inSeconds ~/ 10;
      debugPrint("delta=$delta, _passedIndex = $passedIndex");
      if (_passedIndex != passedIndex) {
        setState(() {
          _passedIndex = passedIndex;
          // update all
        });
      }
    }
  }

  Duration? _getDelta() {
    final now = DateTime.now();
    final delta = _startedAt?.difference(now).abs();
    return delta;
  }

  _stopTimer() {
    _timer?.cancel();
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
              onPressed: () => setState(() => _selected.clear()),
              icon: Icon(Icons.undo)),
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings)),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: MediaQuery.of(context).orientation == Orientation.portrait ? 1.2 : 2.7,
            child: Stack(
              children: [
                Visibility(
                  visible: true,
                  child: Center(
                    child: Text(_getDelta()?.inSeconds?.toString() ?? "-/-"),
                  ),
                ),
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
                                if (_selected.contains(_touchedIndex)) {
                                  _selected.remove(_touchedIndex);
                                }
                                else {
                                  if (_selected.length < 10) {
                                    _selected.add(_touchedIndex);
                                  }
                                  else {
                                    toastInfo(context, "max 10 sctions allowed");
                                  }
                                }
                              }
                              debugPrint("_selected=$_selected");

                            });
                          }),
                      borderData: FlBorderData(
                          show: false
                      ),
                      sectionsSpace: 1,
                      centerSpaceRadius: CENTER_RADIUS,
                      sections: _createSections(),
                      startDegreeOffset: 270
                  ),
                  swapAnimationDuration: Duration(milliseconds: 75),
                ),
              ],
            ),
          ),
          CupertinoButton(
              child: Text("Start"),
              onPressed: () async {
                if (_isRunning()) {
                  toastInfo(context, "Stop it first");
                  return;
                }
                if (_selected.isEmpty) {
                  toastInfo(context, "nothing selected");
                  return;
                }

                _startTimer();
                SignalService.makeSignalPattern(START);
                notify(0, "START", true, preferenceService: _preferenceService, notificationService: _notificationService);

                final list = _selected.toList()..sort();
                debugPrint("$list");
                for (int i=0; i < list.length; i++) {
                  final signal = i + 1;
                  final slice = list[i];
                  Function f = signalFunction(signal);
                  AndroidAlarmManager.oneShot(alarmClock: true, wakeup: true, allowWhileIdle: true, exact: true,
                      _getDelay(slice), signal, f)
                      .then((value) => debugPrint("shot $signal on $slice: $value"));
                }

                AndroidAlarmManager.oneShot(alarmClock: true, wakeup: true, allowWhileIdle: true, exact: true,
                    _getDelay(MAX_SLICE), 1000, signalEnd)
                    .then((value) => debugPrint("shot end: $value"));

                _updateRunning();

              }),
          CupertinoButton(
              child: Text("Stop"),
              onPressed: () {
                debugPrint("stopped");
                _stopTimer();
                _notificationService.cancelAllNotifications();
                SignalService.makeSignalPattern(CANCEL);
                for (int slice = 1; slice <= MAX_SLICE; slice++) {
                  AndroidAlarmManager.cancel(slice);
                }
                AndroidAlarmManager.cancel(1000);
                })
        ],
      ),
    );
  }

  Duration _getDelay(int slice) => kReleaseMode ? Duration(minutes: 1 * slice) : Duration(seconds: 10 * slice);

  List<PieChartSectionData> _createSections() {
    var slices = new List<int>.generate(MAX_SLICE, (i) => i + 1);
    double r = (MediaQuery.of(context).size.width / 2) - CENTER_RADIUS - (20 * 2);

    return slices.map((i) {
      final isTouched = i == _touchedIndex;
      final isPassed = i <= _passedIndex;
      var radius = isTouched ? r * 1.5 : r;
      if (isPassed) {
        radius = radius * 1.1;
      }

      final value = 1.0;

      return PieChartSectionData(
        color: i == MAX_SLICE
            ? ACCENT_COLOR
            : BUTTON_COLOR.withOpacity(
            _selected.contains(i)
              ? (isPassed ? 1 : 0.9)
              : (isPassed ? 0.7 : 0.4)
        ),
        value: value,
        showTitle: i % 2 == 0,
        radius: radius,
        title: i.toString(),
        //    borderSide: BorderSide(color: Colors.amber)
      );
    }).toList();
  }

  bool _isRunning() => _startedAt != null;
}

