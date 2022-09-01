
import 'package:bdt/model/AudioScheme.dart';

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