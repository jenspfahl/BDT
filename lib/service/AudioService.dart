import 'dart:async';

import 'package:bdt/model/AudioScheme.dart';
import 'package:bdt/ui/VolumeSliderDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_bridge/flutter_sound_bridge.dart';
import 'package:vibration/vibration.dart';

import '../model/ColorScheme.dart';
import '../util/prefs.dart';
import 'PreferenceService.dart';




class AudioService {
  static final AudioService _service = AudioService._internal();

  factory AudioService() {
    return _service;
  }

  AudioService._internal() {}


  AudioScheme getCurrentScheme() {
    return getScheme(PreferenceService().audioSchema);
  }

  AudioScheme getScheme(int id) {
    return predefinedAudioSchemes.where((element) => element.id == id).first;
  }

}