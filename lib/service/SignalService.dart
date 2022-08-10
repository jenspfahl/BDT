import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:vibration/vibration.dart';


final START = "||";
final CANCEL = "|";
final SIG_1 = "|| -";
final SIG_2 = "|| --";
final SIG_3 = "|| ---";
final SIG_4 = "|| ----";
final SIG_5 = "|| _";
final SIG_6 = "|| _-";
final SIG_7 = "|| _--";
final SIG_8 = "|| _---";
final SIG_9 = "|| _----";
final SIG_10 = "|| __";
final END = "|| ___";

class SignalService {

  /**
   *     "||--___ ___ ";

   */
  static Future<void> makeSignalPattern(String pattern) async {
    for (int i = 0; i < pattern.length; i++) {
      var character=new String.fromCharCode(pattern.codeUnitAt(i));
      switch (character) {
        case "|" : await makeShortSignal(); break;
        case "-" : await makeNormalSignal(); break;
        case "_" : await makeLongSignal(); break;
        case " " : await pause(Duration(milliseconds: 500)); break;
      }
    }
  }

  static Future<void> makeShortSignal() async {
    await pause(Duration(milliseconds: 50));
    await makeSignal(Duration(milliseconds: 50));
    await pause(Duration(milliseconds: 50));
  }

  static Future<void> makeNormalSignal() async {
    await pause(Duration(milliseconds: 200));
    await makeSignal(Duration(milliseconds: 300));
    await pause(Duration(milliseconds: 200));
  }

  static Future<void> makeLongSignal() async {
    await pause(Duration(milliseconds: 200));
    await makeSignal(Duration(milliseconds: 1000));
    await pause(Duration(milliseconds: 200));
  }

  static Future<void> makeSignal(Duration duration) async {
    debugPrint("signal $duration");
    var hasVibration = await Vibration.hasVibrator() ?? false;

    if (hasVibration) {
      Vibration.vibrate(duration: duration.inMilliseconds);
    }

    await FlutterBeep.playSysSound(
        AndroidSoundIDs.TONE_DTMF_C); //TONE_DTMF_C
    await pause(duration);
    await FlutterBeep.playSysSound(
        AndroidSoundIDs.TONE_CDMA_CALL_SIGNAL_ISDN_PAT3); // silent tone
  }

  static pause(Duration duration) => Future.delayed(duration);


}