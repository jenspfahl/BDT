

import 'package:flutter/material.dart';

import '../model/ColorScheme.dart';
import '../ui/utils.dart';
import 'PreferenceService.dart';




class ColorService {
  static final ColorService _service = ColorService._internal();

  Color? _darkPrimary;
  MaterialColor? _darkPrimarySwatch;
  Color? _lightPrimary;
  MaterialColor? _lightPrimarySwatch;

  bool isDynamicColorsSupported = false;

  factory ColorService() {
    return _service;
  }

  ColorService._internal() {}


  BdtColorScheme getCurrentScheme() {
    return getScheme(PreferenceService().colorSchema);
  }

  BdtColorScheme getScheme(int id) {

 
    final usesDarkTheme = PreferenceService().darkTheme;

    if (dynamicColorsConfigured() && PreferenceService().useSystemColors) {
      if (usesDarkTheme) {
        return BdtColorScheme(
            -1,
            "Dynamic Colors",
            _darkPrimary!,
            _darkPrimarySwatch!,
            Colors.white,
            darker(_darkPrimary!, 62),
            Colors.black);
      }
      else {
        return BdtColorScheme(
            -1,
            "Dynamic Colors",
            _lightPrimary!,
            _lightPrimarySwatch!,
            Colors.black,
            lighter(_lightPrimary!, 62),
            Colors.white);
      }
    }
    else {
      final scheme = predefinedColorSchemes
          .where((element) => element.id == id)
          .firstOrNull ?? predefinedColorSchemes.first;

      return usesDarkTheme ? scheme : scheme.darken();
    }

  }

  void setDynamicColors(Color darkPrimary, Color lightPrimary) {
    this._darkPrimary = darkPrimary;
    this._darkPrimarySwatch = getMaterialColor(darkPrimary);

    this._lightPrimary = lightPrimary;
    this._lightPrimarySwatch = getMaterialColor(lightPrimary);

  }

  bool dynamicColorsConfigured() => isDynamicColorsSupported && _darkPrimary != null && _lightPrimary != null;
  
}