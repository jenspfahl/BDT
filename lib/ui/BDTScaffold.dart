import 'dart:async';
import 'dart:io';

import 'package:bdt/service/SignalService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bdt/service/LocalNotificationService.dart';
import 'package:bdt/service/PreferenceService.dart';


import '../main.dart';
import '../service/LocalNotificationService.dart';
import '../service/PreferenceService.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:sound_generator/sound_generator.dart';
import 'package:sound_generator/waveTypes.dart';


class BDTScaffold extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return BDTScaffoldState();
  }
}

class BDTScaffoldState extends State<BDTScaffold> {

  final _notificationService = LocalNotificationService();
  final _preferenceService = PreferenceService();

  int _touchedIndex = -1;


  static Future<void> handle() async {
    debugPrint("hit it once");
    await SignalService.makeSignalPattern("");
  }

  @override
  void initState() {
    super.initState();

   // SoundGenerator.init(9600);

 //   SoundGenerator.setAutoUpdateOneCycleSample(true);
    //Force update for one time
  //  SoundGenerator.refreshOneCycleData();
  }

  @override
  void dispose() {
    super.dispose();
  //  SoundGenerator.release();
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
                SignalService.makeSignalPattern("");

                AndroidAlarmManager.oneShot(alarmClock: true, wakeup: true, allowWhileIdle: true,
                     const Duration(seconds: 10), 12345, handle)
                    .then((value) => debugPrint("value=$value"));

          }),
          CupertinoButton(
              child: Text("Stop"),
              onPressed: () {
                debugPrint("stopped");

                AndroidAlarmManager.cancel(12345);
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
