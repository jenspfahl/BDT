import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:sound_generator/sound_generator.dart';
import 'package:sound_generator/waveTypes.dart';
import 'package:vibration/vibration.dart';

class SignalService {


  static Future<void> makeSignal(Duration duration) async {
    debugPrint("signal");
    var hasVibration = await Vibration.hasVibrator() ?? false;
  //  await SoundGenerator.init(9600);

    if (hasVibration) {
      Vibration.vibrate(duration: duration.inMilliseconds);
    }
    "||--___ ___ ";
 /*   SoundGenerator.setWaveType(waveTypes.TRIANGLE);
    SoundGenerator.setVolume(100);
    SoundGenerator.setFrequency(800);
    SoundGenerator.play();
    sleep(duration);
    SoundGenerator.stop();
    SoundGenerator.release();*/

    await FlutterBeep.beep(false);
    sleep(duration);
    await FlutterBeep.beep(true);
    /*await FlutterBeep.playSysSound(
        AndroidSoundIDs.TONE_CDMA_ABBR_ALERT);*/

  }
}