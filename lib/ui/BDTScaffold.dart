import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bdt/service/BreakDownService.dart';
import 'package:bdt/service/LocalNotificationService.dart';
import 'package:bdt/service/PreferenceService.dart';
import 'package:bdt/service/SignalService.dart';
import 'package:bdt/ui/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:slider_button/slider_button.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:system_clock/system_clock.dart';

import '../model/BreakDown.dart';
import '../service/ColorService.dart';
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


final MAX_BREAKS = 20;
final MAX_SLICE = 60;
final CENTER_RADIUS = 60.0;

class BDTScaffoldState extends State<BDTScaffold> {

  int _touchedIndex = -1;
  int _passedIndex = -1;

  Duration _duration = kReleaseMode ? Duration(minutes: 60): Duration(seconds: 60);
  late DateTime _time;

  final _selectedSlices = HashSet<int>();
  int? _pinnedBreakDownId;

  TimerMode _timerMode = TimerMode.RELATIVE;
  Direction _direction = Direction.ASC;

  List<BreakDown> _loadedBreakDowns = predefinedBreakDowns;
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

  static Future<void> signal11() async {
    debugPrint("sig 11");

    await notifySignal(11);
    await SignalService.makeSignalPattern(SIG_11);
  }

  static Future<void> signal12() async {
    debugPrint("sig 12");

    await notifySignal(12);
    await SignalService.makeSignalPattern(SIG_12);
  }

  static Future<void> signal13() async {
    debugPrint("sig 13");

    await notifySignal(13);
    await SignalService.makeSignalPattern(SIG_13);
  }

  static Future<void> signal14() async {
    debugPrint("sig 14");

    await notifySignal(14);
    await SignalService.makeSignalPattern(SIG_14);
  }

  static Future<void> signal15() async {
    debugPrint("sig 15");

    await notifySignal(15);
    await SignalService.makeSignalPattern(SIG_15);
  }

  static Future<void> signal16() async {
    debugPrint("sig 16");

    await notifySignal(16);
    await SignalService.makeSignalPattern(SIG_16);
  }

  static Future<void> signal17() async {
    debugPrint("sig 17");

    await notifySignal(17);
    await SignalService.makeSignalPattern(SIG_17);
  }

  static Future<void> signal18() async {
    debugPrint("sig 18");

    await notifySignal(18);
    await SignalService.makeSignalPattern(SIG_18);
  }

  static Future<void> signal19() async {
    debugPrint("sig 19");

    await notifySignal(19);
    await SignalService.makeSignalPattern(SIG_19);
  }

  static Future<void> signal20() async {
    debugPrint("sig 20");

    await notifySignal(20);
    await SignalService.makeSignalPattern(SIG_20);
  }
  
  static Future<void> signalEnd() async {
    debugPrint("sig end");
    await notify(100, "Timer finished", showBreakInfo: true, showProgress: true);
    await SignalService.makeSignalPattern(SIG_END);
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
    throw Exception("unknown signal $signal");
  }

  static Future<void> notifySignal(int signal) async {
    final prefService = PreferenceService();
    final breaksCount = await getBreaksCount(prefService);

    final signalAsString = _breakNumberToString(signal);
    await notify(signal, "Break $signalAsString of $breaksCount reached",
        showProgress: true, showBreakInfo: true, fixed: true);
  }

  static String _breakNumberToString(int signal) => signal <= 10 ? signal.toString() : "10+${signal-10} ($signal)";

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

    getPinnedBreakDown(_preferenceService).then((value) {
      setState(() => _pinnedBreakDownId = value);
    });

    _loadBreakDowns(true);
    _updateBreakOrder();

    getVolume(_preferenceService).then((value) {
      if (value != null) {
        setState(() => _volume = value);
      }
    });
    SoundMode.ringerModeStatus.then((value) => _ringerStatus = value);

    Timer.periodic(Duration(seconds: 15), (_) {
      if (mounted) {
        setState(() {
          SoundMode.ringerModeStatus.then((value) => _ringerStatus = value);
          debugPrint("refresh ui values");
        });
      }
    });

    getRunState(_preferenceService).then((persistedState) {
      if (persistedState != null) {
        Map<String, dynamic> stateAsJson = jsonDecode(persistedState);
        debugPrint("!!!!!!FOUND persisted state: $stateAsJson");
        final lastBoot = DateTime.now().subtract(SystemClock.elapsedRealtime());
        final persistedStateFrom = DateTime.fromMillisecondsSinceEpoch(stateAsJson['startedAt']);
        debugPrint("last boot was ${formatDateTime(lastBoot)}, persisted state is from ${formatDateTime(persistedStateFrom)}");
        if (lastBoot.isBefore(persistedStateFrom)) {
          debugPrint("State is from this session, using it");
          _setStateFromJson(stateAsJson);
          _startTimer();
        }
        else {
          debugPrint("State is outdated, deleting it");
          setRunState(_preferenceService, null);
        }
      }
    });
  }

  void _loadBreakDowns(bool focusPinned) {
    BreakDownService().getAllBreakDowns()
        .then((value) {
          setState(() {
            _loadedBreakDowns = value;
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
    _runTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isOver()) {
        timer.cancel();
      }
      if (mounted) {
        _updateRunning();
        debugPrint(".. timer refresh #${_runTimer?.tick} ..");
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
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      List<Widget> rows = new List<int>.generate(MAX_BREAKS, (i) => i + 1)
                      .map((i) => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
                            child: _getIconForNumber(i, MAX_BREAKS, forceAsc: true)!,
                          ),
                          Text("Break ${_breakNumberToString(i)}: "),
                          Text(_getSignalStringForNumber(i), style: TextStyle(fontSize: 10),),
                        ]))
                            .toList();

                        rows.add(Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                              child: Text(""),
                            ),
                            Text("Timer end: "),
                            Text(_getSignalStringForNumber(100), style: TextStyle(fontSize: 10),),
                          ])
                      );
                      return AlertDialog(
                        insetPadding: EdgeInsets.zero,
                        contentPadding: EdgeInsets.all(16),
                        title: Column(
                          children: [
                            Text("Help"),
                            Text(""),
                            Text("With this timer you can define relative in-between notifications to get informed about the progress of the passed timer time.",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                            Text("Choose a duration or a timer time by clicking on the center of the wheel and select breaks on the wheel by clicking on a slice. A break is just an acoustic signal and/or vibration with a unique pattern like follows:",
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
                            child: Text("Close"),
                            onPressed:  () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    }
                );
              },
              icon: Icon(Icons.help_outline)),
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
                      color: _isRunning() || _isBreakDownSelectionAtStart() ? Colors.grey[700] : ColorService().getCurrentScheme().button,
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
                      isDense: true,
                      focusColor: ColorService().getCurrentScheme().accent,
                      onTap: () => FocusScope.of(context).unfocus(),
                      value: _selectedBreakDown,
                      hint: Text("Break downs"),
                      iconEnabledColor: ColorService().getCurrentScheme().button,
                      icon: Icon(Icons.av_timer),
                      isExpanded: true,
                      onChanged:  _isRunning() ? null : (value) {
                        _updateSelectedSlices(value);
                      },
                      items: _loadedBreakDowns.map((BreakDown breakDown) {
                        debugPrint("inList=$breakDown");
                        return DropdownMenuItem(
                          value: breakDown,
                          child: breakDown.id == _pinnedBreakDownId
                              ? Row(children: [
                                      Icon(Icons.push_pin),
                                      Text(breakDown.name)
                                ])
                              : Text(breakDown.name),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Flexible(child: IconButton(
                  color: _isRunning() || _isBreakDownSelectionAtEnd() ? Colors.grey[700] : ColorService().getCurrentScheme().button,
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
              backgroundColor: ColorService().getCurrentScheme().background,
              thumbColor: ColorService().getCurrentScheme().button,
              padding: EdgeInsets.all(8),
              children: <TimerMode, Widget> {
                TimerMode.RELATIVE: Icon(Icons.timer_outlined, color: _timerMode == TimerMode.RELATIVE ? ColorService().getCurrentScheme().accent : ColorService().getCurrentScheme().button),
                TimerMode.ABSOLUTE: Icon(Icons.alarm, color: _timerMode == TimerMode.ABSOLUTE ? ColorService().getCurrentScheme().accent : ColorService().getCurrentScheme().button),
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
                                    if (_selectedSlices.length < MAX_BREAKS) {
                                      _selectedSlices.add(_touchedIndex);
                                    }
                                    else {
                                      toastError(context, "max $MAX_BREAKS breaks allowed");
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
                  Visibility(
                    visible: _selectedBreakDown != null,
                    child: Positioned(
                      top: 20,
                      left: 20,
                      child: IconButton(
                          color: ColorService().getCurrentScheme().button,
                          onPressed: () {
                            if (_isRunning()) {
                              toastError(context, "Stop running first");
                              return;
                            }
                            if (_selectedBreakDown != null) {
                              setState(() {
                                if (_isPinnedBreakDown()) {
                                  _pinnedBreakDownId = null;
                                  toastInfo(context, "Preset '${_selectedBreakDown?.name}' unpinned");
                                }
                                else {
                                  _pinnedBreakDownId = _selectedBreakDown?.id;
                                  toastInfo(context, "Preset '${_selectedBreakDown?.name}' pinned");
                                }
                                setPinnedBreakDown(_preferenceService, _pinnedBreakDownId);
                              });
                            }
                          },
                          icon: _isPinnedBreakDown()
                              ? Icon(Icons.push_pin)
                              : Icon(Icons.push_pin_outlined),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _hasSliceSelectionChanged() || _canDeleteUnchangedUserBreakDown(),
                    child: Positioned(
                      bottom: 20,
                      left: 20,
                      child: IconButton(
                          color: ColorService().getCurrentScheme().button,
                          onPressed: () {
                            if (_isRunning()) {
                              toastError(context, "Stop running first");
                              return;
                            }
                            if (_canDeleteUnchangedUserBreakDown()) {
                              final breakDownName = _selectedBreakDown?.name;
                              showConfirmationDialog(context, "Delete saved preset", "Are you sure to delete '$breakDownName' permanently?",
                              okPressed: () {
                                if (_selectedBreakDown != null) {
                                  BreakDownService().deleteBreakDown(_selectedBreakDown!);
                                  if (_isPinnedBreakDown()) {
                                    _pinnedBreakDownId = null;
                                    setPinnedBreakDown(
                                        _preferenceService, _pinnedBreakDownId);
                                  }

                                  _selectedBreakDown = null; // this not in setState
                                  _selectedSlices.clear();
                                  _loadBreakDowns(false);
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
                                newName = newName != null ? newName + " (modified)" : null;
                              }
                              showInputDialog(context, "Save preset", "Enter a name for your preset to save.",
                                  initText: newName,
                                  hintText: "choose a name",
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Preset name missing";
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
                                      toastError(context, "Preset name still used. Choose another one");
                                      return;
                                    }

                                    final newBreakDown = BreakDown(id??0, newName, Set.of(_selectedSlices));
                                    BreakDownService().saveBreakDown(newBreakDown).then((savedBreakDown) {
                                      _selectedBreakDown = savedBreakDown; // this not in setState
                                      _loadBreakDowns(false); // here setState is called

                                      toastInfo(context, "'$newName' saved");
                                    });

                                    Navigator.pop(context);
                                  });
                            }
                          },
                          icon: _canDeleteUnchangedUserBreakDown()
                              ? Icon(Icons.delete_forever)
                              : Icon(Icons.save),
                    )),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      color: ColorService().getCurrentScheme().button,
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
                    bottom: 20,
                    right: 20,
                    child: IconButton(
                      color: ColorService().getCurrentScheme().button,
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
      floatingActionButton: _isRunning() && !_isOver()
          ? _createSwipeToStopButton(context)
          : _createStartButton(context),
    );
  }

  bool _canDeleteUnchangedUserBreakDown() => _selectedBreakDown != null && (_selectedBreakDown?.isPredefined() == false) && !_hasBreakDownChanged();

  bool _hasSliceSelectionChanged() => (_selectedBreakDown?.getSlicesAsString()??"") != _selectedSortedSlicesToString();

  bool _hasBreakDownChanged() {
    return _selectedBreakDown?.getSlicesAsString() != _selectedSortedSlicesToString();
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
      backgroundColor: ColorService().getCurrentScheme().button,
      baseColor: ColorService().getCurrentScheme().primary,
      highlightedColor: ColorService().getCurrentScheme().accent,
      height: 48,
      width: 200,
      buttonSize: 48,
      shimmer: false,
      dismissThresholds: 0.99,
      label: Text("➡️  Swipe to Stop",
          style: TextStyle(letterSpacing: 0.7, fontWeight: FontWeight.w500, color: ColorService().getCurrentScheme().accent)),
      icon: Icon(Icons.stop, color: ColorService().getCurrentScheme().button),
    );
  }

  Widget _createStartButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: ColorService().getCurrentScheme().button,
      splashColor: ColorService().getCurrentScheme().foreground,
      foregroundColor: ColorService().getCurrentScheme().accent,
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
              child: Divider(thickness: 0.5, color: ColorService().getCurrentScheme().accent, height: 5)
          ),
          Text("${formatDuration(Duration.zero)}"),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ColorService().getCurrentScheme().accent, height: 5)
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
              child: Divider(thickness: 0.5, color: ColorService().getCurrentScheme().accent, height: 5)
          ),
          Text("${formatDuration(_getRemaining()!)}"),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ColorService().getCurrentScheme().accent, height: 5)
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
            formatDateTime(_startedAt!, withSeconds: true),
            style: TextStyle(fontSize: 8),
            textAlign: TextAlign.center
          ),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ColorService().getCurrentScheme().accent, height: 5)
          ),
          Text(formatDateTime(_time, withSeconds: true), textAlign: TextAlign.center),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ColorService().getCurrentScheme().accent, height: 5)
          ),
          Text(
            formatDateTime(_time, withSeconds: true),
            style: TextStyle(fontSize: 8),
            textAlign: TextAlign.center
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
    else if (_isRunning()) {
      return Column(
        children: [
          Text(
            formatDateTime(_startedAt!, withSeconds: true),
            style: TextStyle(fontSize: 8),
            textAlign: TextAlign.center
          ),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ColorService().getCurrentScheme().accent, height: 5)
          ),
          Text(formatDateTime(DateTime.now(), withSeconds: true), textAlign: TextAlign.center),
          SizedBox(
              width: 80,
              child: Divider(thickness: 0.5, color: ColorService().getCurrentScheme().accent, height: 5)
          ),
          Text(
            formatDateTime(_time, withSeconds: true),
            style: TextStyle(fontSize: 8),
            textAlign: TextAlign.center
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
    else {
      return Text(formatDateTime(_time));
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
        setState(() {
          _duration = _tempSelectedDuration ?? initialDuration;
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
        debugPrint("tranSec=$transitionSeconds / sliceSec=$sliceSeconds");
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
        title: _showSliceTitle(slice, isInTransition),
        titleStyle:
          isFinalSlice
              ? TextStyle(fontSize: 14)
              : isInTransition
                ? TextStyle(fontSize: 8)
                : TextStyle(fontSize: 10),
        titlePositionPercentageOffset: isTouched ? 0.9 : 1.23,//isFinalSlice ? (_isRunning() ? (isPassed ? 1.23 : 1.45) : 1.4) : 1.23,
        badgeWidget: isSelected ? _getIconForNumber(indexOfSelected, _selectedSlices.length) : null,
      );
    }).toList();
  }

  String _showSliceTitle(int slice, bool showCurrent) {
    if (_timerMode == TimerMode.RELATIVE) {
      final sliceDuration = _getDelay(slice);
      return formatDuration(
          showCurrent ? _getDelta()??sliceDuration : sliceDuration,
          withLineBreak: true,
          noSeconds: _duration.inMinutes >= 60);
    }
    else if (_timerMode == TimerMode.ABSOLUTE) {
      final nowOrStartedAt = _startedAt ?? DateTime.now();
      final delta = nowOrStartedAt.difference(_time).abs();
      final sliceDuration = Duration(seconds: delta.inSeconds * slice ~/ MAX_SLICE);
      debugPrint("nowOrStartedAt=$nowOrStartedAt delta=${delta.inMinutes} sl=$slice sliceDur=$sliceDuration");
      final sliceTime = nowOrStartedAt.add(sliceDuration);
      return formatDateTime(
          showCurrent ? DateTime.now() : sliceTime,
          withLineBreak: true,
          withSeconds: delta.inMinutes < 10);
    }
    else {
      throw Exception("unknown timerMode " + _timerMode.toString());
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
    if (_timerMode == TimerMode.ABSOLUTE && _isTimeElapsed()) {
      toastError(context, "Time already reached, set a new one");
      return;
    }

    _startedAt = DateTime.now();
    _startTimer();
    _updateRunning();

    final startedAt = _startedAt;
    if (startedAt == null) { // should not happen
      throw Exception("_startedAt should not be null here");
    }

    final stateAsJson = jsonEncode(this);
    debugPrint("!!!!State to persist: $stateAsJson");
    setRunState(_preferenceService, stateAsJson);

    if (_timerMode == TimerMode.RELATIVE) {
      setState(() => _time = startedAt.add(_duration));
    }
    else if (_timerMode == TimerMode.ABSOLUTE) {
      setState(() {
        _duration = startedAt.difference(_time).abs();
      });
    }
    SignalService.makeSignalPattern(START,
        volume: _volume, preferenceService: _preferenceService);
    notify(0, "Timer started",
        preferenceService: _preferenceService,
        notificationService: _notificationService,
        showProgress: true,
        showStartInfo: true,
        fixed: true);

    final list = _selectedSortedSlices();
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

  bool _isTimeElapsed() => !truncToMinutes(_time).isAfter(truncToMinutes(DateTime.now()));

  void _stopRun(BuildContext context) {
    debugPrint("stopped");
    _stopTimer();
    setRunState(_preferenceService, null);
    _notificationService.cancelAllNotifications();
    SignalService.makeSignalPattern(CANCEL,
        volume: _volume, preferenceService: _preferenceService);
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
    'timerMode': _timerMode.index,
    'direction': _direction.index,
    'startedAt': _startedAt?.millisecondsSinceEpoch,
    'selectedSlices': _selectedSortedSlicesToString(),
    'selectedBreakDown': _selectedBreakDown?.id,
  };
  }

  String _selectedSortedSlicesToString() => _selectedSortedSlices().join(",");

  void _setStateFromJson(Map<String, dynamic> jsonMap) {
    _duration = Duration(seconds: jsonMap['duration']);
    _time = DateTime.fromMillisecondsSinceEpoch(jsonMap['time']);
    _timerMode = TimerMode.values.elementAt(jsonMap['timerMode']);
    _direction = Direction.values.elementAt(jsonMap['direction']);
    _startedAt = DateTime.fromMillisecondsSinceEpoch(jsonMap['startedAt']);

    _selectedSlices.clear();
    jsonMap['selectedSlices'].toString().split(",")
        .map((e) => int.parse(e))
        .forEach((e) => _selectedSlices.add(e));

    if (jsonMap['selectedBreakDown'] != null) {
      _selectedBreakDown = _loadedBreakDowns
          .where((e) => e.id == jsonMap['selectedBreakDown'])
          .first;
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
    throw Exception("unknown signal $signal");
  }

  bool _isPinnedBreakDown() => _selectedBreakDown != null && _selectedBreakDown?.id == _pinnedBreakDownId;

}

