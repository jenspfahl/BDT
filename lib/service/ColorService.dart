

import 'package:bdt/ui/utils.dart';

import '../model/ColorScheme.dart';
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
    final usesDarkTheme = PreferenceService().darkTheme;

    final scheme = predefinedColorSchemes.where((element) => element.id == id).first;

    return usesDarkTheme ? scheme : scheme.darken();
  }

}