import 'dart:async';

import 'package:bdt/ui/VolumeSliderDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_bridge/flutter_sound_bridge.dart';
import 'package:vibration/vibration.dart';

import '../util/prefs.dart';
import 'PreferenceService.dart';


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
  static makeSignalPattern(String pattern, {
    int? volume,
    PreferenceService? preferenceService
  }) async {
    final prefService = preferenceService ?? PreferenceService();

    final vol = volume ?? await getVolume(prefService) ?? MAX_VOLUME;
    debugPrint("volume $vol");

    SignalService.setSignalVolume(vol);

    for (int i = 0; i < pattern.length; i++) {
      var character=new String.fromCharCode(pattern.codeUnitAt(i));
      switch (character) {
        case "|" : await makeShortSignal(); break;
        case "-" : await makeNormalSignal(); break;
        case "_" : await makeLongSignal(); break;
        case " " : await pause(Duration(milliseconds: 1000)); break;
      }
    }
  }

  static makeShortSignal() async {
    await makeSignal(Duration(milliseconds: 50));
    await pause(Duration(milliseconds: 300));
  }

  static makeNormalSignal() async {
    await makeSignal(Duration(milliseconds: 400));
    await pause(Duration(milliseconds: 400));
  }

  static makeLongSignal() async {
    await makeSignal(Duration(milliseconds: 1000));
    await pause(Duration(milliseconds: 400));
  }

  static makeSignal(Duration duration) async {
    debugPrint("signal $duration");
    final vibrateAllowed = await mayVibrate(PreferenceService());

    if (vibrateAllowed) {
      final hasVibration = await Vibration.hasVibrator() ?? false;
      if (hasVibration) {
        Vibration.vibrate(duration: duration.inMilliseconds);
      }
    }

    await FlutterSoundBridge.playSysSound(
        AndroidSoundIDs.TONE_DTMF_C, duration); //TONE_DTMF_C
    await pause(duration);
  }

  static pause(Duration duration) async => Future.delayed(duration);

  static setSignalVolume(int volume) async {
    await FlutterSoundBridge.setVolume(volume);
  }

}