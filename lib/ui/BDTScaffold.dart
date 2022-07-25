import 'dart:async';
import 'dart:ffi';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bdt/service/LocalNotificationService.dart';
import 'package:bdt/service/PreferenceService.dart';
import 'package:bdt/service/SignalService.dart';
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


  int _touchedIndex = -1;
  final _notificationService = LocalNotificationService();
  final _preferenceService = PreferenceService();


  static Future<void> signal7() async {
    debugPrint("sig 7");

    await notifySignal(7);
    await SignalService.makeSignalPattern(SIG_7);
  }

  static Future<void> signalEnd() async {
    debugPrint("sig end");
    await notify(100, "END", false);
    await SignalService.makeSignalPattern(END);
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: MediaQuery.of(context).orientation == Orientation.portrait ? 1.2 : 2.7,
            child: Stack(
              children: [
                Visibility(
                  visible: true,
                  child: Center(
                    child: Icon(Icons.abc),
                  ),
                ),
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedIndex = -1;
                              return;
                            }
                            _touchedIndex =
                                pieTouchResponse.touchedSection!.touchedSectionIndex + 2;
                          });
                        }),
                    borderData: FlBorderData(
                      show: false
                    ),
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: _createSections(),
                    startDegreeOffset: 279
                  ),
                  swapAnimationDuration: Duration(milliseconds: 75),
                ),
              ],
            ),
          ),
          CupertinoButton(
              child: Text("Start"),
              onPressed: () async {
                SignalService.makeSignalPattern(START);
                notify(0, "START", true, preferenceService: _preferenceService, notificationService: _notificationService);

                AndroidAlarmManager.oneShot(alarmClock: true, wakeup: true, allowWhileIdle: true, exact: true,
                     kReleaseMode ? Duration(minutes: 1) : Duration(seconds: 10), 1, signal7)
                    .then((value) => debugPrint("shot 7: $value"));

                AndroidAlarmManager.oneShot(alarmClock: true, wakeup: true, allowWhileIdle: true, exact: true,
                    kReleaseMode ? Duration(minutes: 2) : Duration(seconds: 20), 100, signalEnd)
                    .then((value) => debugPrint("shot end: $value"));

          }),
          CupertinoButton(
              child: Text("Stop"),
              onPressed: () {
                debugPrint("stopped");
                _notificationService.cancelAllNotifications();
                SignalService.makeSignalPattern(CANCEL);
                AndroidAlarmManager.cancel(1);
                AndroidAlarmManager.cancel(100);
          })
        ],
      ),
    );
  }

  List<PieChartSectionData> _createSections() {
    var slices = new List<int>.generate(60, (i) => i + 1).map((e) => e + 1);


    return slices.map((i) {
      final isTouched = i == _touchedIndex;
      final r = 70.0;
      final radius = isTouched ? r * 1.5 : r;

      final value = 1.0;

      return PieChartSectionData(
        color: i == 60 ? Colors.red : Colors.amber,
        value: value,
        showTitle: i % 2 == 0,
        radius: radius,
        title: i.toString(),
    //    borderSide: BorderSide(color: Colors.amber)
      );
    }).toList();
  }

}
