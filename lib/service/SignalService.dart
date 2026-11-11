import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:bdt/service/AudioService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_bridge/flutter_sound_bridge.dart';
import 'package:sound_mode_advanced/sound_mode.dart';
import 'package:sound_mode_advanced/sound_mode_advanced.dart';
import 'package:vibration/vibration.dart';

import '../model/AudioScheme.dart';
import '../util/prefs.dart';
import 'PreferenceService.dart';


final START = '||';
final CANCEL = '|';
final PRE_START = '-';
final SIG_UNSPEC = '||';
final SIG_UNSPEC_END = '|||';
final SIG_PRE_A = '|| ';
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
final SIG_PRE_B = '||| ';
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
  }) async {
    final prefService = preferenceService ?? PreferenceService();

    final vol = volume ?? await getVolume(prefService);

    final muteVolumeIfDeviceIsMuted = prefService.muteVolumeIfDeviceIsMuted;
    final ringerStatus = await SoundMode.ringerModeStatus;
    final isSilent = ringerStatus == RingerModeStatus.silent || ringerStatus == RingerModeStatus.vibrate;
    await SignalService.setSignalVolume(vol, muteVolumeIfDeviceIsMuted && isSilent);

    final signalTwice = await shouldSignalTwice(prefService);
    final signalWithoutNumber = await shouldSignalWithoutEncodedNumber(prefService);
    final signalWithoutPreSignal = await shouldSignalWithoutPreSignal(prefService);

    pattern = adaptPattern(pattern, signalWithoutNumber, signalWithoutPreSignal);

    if (signalTwice && !neverSignalTwice) {
      pattern = pattern + ' ' + ' ' + pattern; // add two breaks aka 2 seconds in between
    }

    await _startMakeSignalPattern(pattern, prefService);

  }

  static _startMakeSignalPattern(String pattern, PreferenceService preferenceService) async {

    final audioScheme = AudioService().getScheme(preferenceService.audioSchema);
    final vibrate = await mayVibrate(PreferenceService());

    await FlutterSoundBridge.playPattern(audioScheme.soundId, pattern, vibrate);

  }

  static String adaptPattern(String pattern, bool signalWithoutNumber, bool signalWithoutPreSignal) {
    if (signalWithoutNumber) {
      if (pattern != START && pattern != CANCEL && pattern != SIG_END) {
        pattern = SIG_UNSPEC;
      }
      else if (pattern == SIG_END) {
        pattern = SIG_UNSPEC_END;
      }
    }
    else if (signalWithoutPreSignal ) {
      if (pattern.startsWith(SIG_PRE_A)) {
        pattern = pattern.replaceFirst(SIG_PRE_A, '');
      }
      else if (pattern.startsWith(SIG_PRE_B)) {
        pattern = pattern.replaceFirst(SIG_PRE_B, '');
      }
    }
    return pattern;
  }

  static Future<String> signalPatternToString(String pattern) async {
    final signalWithoutNumber = await shouldSignalWithoutEncodedNumber(PreferenceService());
    final signalWithoutPreSignal = await shouldSignalWithoutPreSignal(PreferenceService());

    pattern = adaptPattern(pattern, signalWithoutNumber, signalWithoutPreSignal);
    return pattern.characters.map((character) {
      switch (character) {
        case '|' : return 'bep ';
        case '-' : return 'beep ';
        case '_' : return 'beeeeep ';
        case ' ' : return '   ';
      }
    }).join();
  }

  static makeSignal(Duration duration, {int? audioSchemeId}) async {
    debugPrint('signal $duration');
    final audioScheme = AudioService().getScheme(audioSchemeId ?? PreferenceService().audioSchema);

    await FlutterSoundBridge.playSound(
        audioScheme.soundId, duration);

  }

  static setSignalVolume(int volume, bool muteVolume) async {
    await FlutterSoundBridge.setVolume(muteVolume ? 0 : volume, AudioStreams.STREAM_ALARM);
  }

  Future<void> stopAll() async {
    await FlutterSoundBridge.stopSoundOrPattern();
  }

}