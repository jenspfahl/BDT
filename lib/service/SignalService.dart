import 'dart:async';
import 'dart:math';

import 'package:bdt/service/AudioService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_bridge/flutter_sound_bridge.dart';
import 'package:vibration/vibration.dart';

import '../util/prefs.dart';
import 'PreferenceService.dart';


final START = '||';
final CANCEL = '|';
final SIG_1 = '|| -';
final SIG_2 = '|| --';
final SIG_3 = '|| ---';
final SIG_4 = '|| ----';
final SIG_5 = '|| _';
final SIG_6 = '|| _-';
final SIG_7 = '|| _--';
final SIG_8 = '|| _---';
final SIG_9 = '|| _----';
final SIG_10 = '|| __';
final SIG_11 = '||| -';
final SIG_12 = '||| --';
final SIG_13 = '||| ---';
final SIG_14 = '||| ----';
final SIG_15 = '||| _';
final SIG_16 = '||| _-';
final SIG_17 = '||| _--';
final SIG_18 = '||| _---';
final SIG_19 = '||| _----';
final SIG_20 = '||| __';
final SIG_END = '|| ___';

class SignalService {

  /**
   *     "||--___ ___ ";

   */
  static makeSignalPattern(String pattern, {
    int? volume,
    PreferenceService? preferenceService,
    bool neverSignalTwice = false,
    bool signalAlthoughCancelled = false
  }) async {
    final prefService = preferenceService ?? PreferenceService();
    final id = Random().nextInt(10000000);

    await initCurrentSignalling(prefService, id);

    final vol = volume ?? await getVolume(prefService);
    final signalTwice = await shouldSignalTwice(PreferenceService());
    debugPrint('volume $vol signal twice=$signalTwice');

    SignalService.setSignalVolume(vol);

    await _makeSignalPattern(pattern, prefService, id, signalAlthoughCancelled);

    if (!signalAlthoughCancelled && await _cancelSignalling(prefService, id)) {
      return;
    }

    if (signalTwice && !neverSignalTwice) {
      await pause(Duration(seconds: 2));
      await _makeSignalPattern(pattern, prefService, id, signalAlthoughCancelled);
    }
  }

  static Future<bool> _cancelSignalling(PreferenceService preferenceService, id) async {
    final otherId = await getCurrentSignalling(preferenceService);
    if (otherId != null && otherId != id) {
      FlutterSoundBridge.stopSysSound(); // async
      debugPrint("cancel due to other signal id $otherId than $id");
      return true;
    }

    bool cancelRequested = await shouldCancelSignalling(preferenceService);
    debugPrint("cancelRequested=$cancelRequested");
    if (cancelRequested) {
      FlutterSoundBridge.stopSysSound(); // async
      debugPrint("cancel due to cancelRequested");
    }
    return cancelRequested;
  }

  static _makeSignalPattern(String pattern, PreferenceService preferenceService,
      int id, bool signalAlthoughCancelled) async {
    await FlutterSoundBridge.stopSysSound();

    for (int i = 0; i < pattern.length; i++) {
      if (!signalAlthoughCancelled && await _cancelSignalling(preferenceService, id)) {
        return;
      }

      var character = String.fromCharCode(pattern.codeUnitAt(i));
      switch (character) {
        case '|' : await makeShortSignal(); break;
        case '-' : await makeNormalSignal(); break;
        case '_' : await makeLongSignal(); break;
        case ' ' : await pause(Duration(milliseconds: 1000)); break;
      }
    }
  }

  static String signalPatternToString(String pattern) {
    return pattern.characters.map((character) {
      switch (character) {
        case '|' : return 'pip ';
        case '-' : return 'piep ';
        case '_' : return 'peeeep ';
        case ' ' : return '   ';
      }
    }).join();
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

  static makeSignal(Duration duration, {int? audioSchemeId}) async {
    debugPrint('signal $duration');
    final vibrateAllowed = await mayVibrate(PreferenceService());
    debugPrint('vibrate $vibrateAllowed');

    if (vibrateAllowed) {
      final hasVibration = await Vibration.hasVibrator() ?? false;
      if (hasVibration) {
        Vibration.vibrate(duration: duration.inMilliseconds);
      }
    }

    final audioScheme = AudioService().getScheme(audioSchemeId ?? PreferenceService().audioSchema);

    await FlutterSoundBridge.playSysSound(
        audioScheme.soundId, duration); //TONE_DTMF_C
    await pause(duration);
  }

  static pause(Duration duration) async => Future.delayed(duration);

  static setSignalVolume(int volume) async {
    await FlutterSoundBridge.setVolume(volume);
  }

  Future<void> stopAll() async {
    PreferenceService().setBool(PreferenceService.STATE_SIGNAL_CANCELLING, true);
    await FlutterSoundBridge.stopSysSound();
  }

}