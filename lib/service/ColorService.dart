import 'dart:async';

import 'package:bdt/ui/VolumeSliderDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_bridge/flutter_sound_bridge.dart';
import 'package:vibration/vibration.dart';

import '../model/ColorScheme.dart';
import '../util/prefs.dart';
import 'PreferenceService.dart';




class ColorService {
  static final ColorService _service = ColorService._internal();

  factory ColorService() {
    return _service;
  }

  ColorService._internal() {}


  BdtColorScheme getCurrentScheme() {
    return getScheme(PreferenceService().colorSchema);
  }

  BdtColorScheme getScheme(int id) {
    return predefinedColorSchemes.where((element) => element.id == id).first;
  }

}