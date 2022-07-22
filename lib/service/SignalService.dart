import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:sound_generator/sound_generator.dart';
import 'package:sound_generator/waveTypes.dart';
import 'package:vibration/vibration.dart';

class SignalService {

  /**
   *     "||--___ ___ ";

   */
  static Future<void> makeSignalPattern(String pattern) async {
    await makeSignal(Duration(milliseconds: 100));
    sleep(Duration(milliseconds: 50));
    await makeSignal(Duration(milliseconds: 50));
    sleep(Duration(milliseconds: 50));
    await makeSignal(Duration(milliseconds: 500));
  }

  static Future<void> makeSignal(Duration duration) async {
    debugPrint("signal");
    var hasVibration = await Vibration.hasVibrator() ?? false;
  //  await SoundGenerator.init(9600);

    if (hasVibration) {
      Vibration.vibrate(duration: duration.inMilliseconds);
    }
 /*   SoundGenerator.setWaveType(waveTypes.TRIANGLE);
    SoundGenerator.setVolume(100);
    SoundGenerator.setFrequency(800);
    SoundGenerator.play();
    sleep(duration);
    SoundGenerator.stop();
    SoundGenerator.release();*/

  /*  await FlutterBeep.beep(true);
    sleep(duration);*/
  //  await FlutterBeep.beep(true);
    await FlutterBeep.playSysSound(
        AndroidSoundIDs.TONE_DTMF_C);
    sleep(duration);
    await FlutterBeep.playSysSound(
        AndroidSoundIDs.TONE_CDMA_CALL_SIGNAL_ISDN_PAT3); // silent tone

  }
}