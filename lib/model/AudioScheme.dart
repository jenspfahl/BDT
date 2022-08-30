import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_sound_bridge/flutter_sound_bridge.dart';


class AudioScheme implements Comparable<AudioScheme> {

  int id;
  String name;
  int soundId;

  AudioScheme(this.id, this.name, this.soundId);

  @override
  int compareTo(AudioScheme other) {
    return id.compareTo(other.id);
  }

}

const DEFAULT_AUDIO_SCHEME_ID = 2; //TONE_DTMF_C

List<AudioScheme> predefinedAudioSchemes = [
  AudioScheme(0, "DTMF A", AndroidSoundIDs.TONE_DTMF_A),
  AudioScheme(1, "DTMF B", AndroidSoundIDs.TONE_DTMF_B),
  AudioScheme(2, "DTMF C", AndroidSoundIDs.TONE_DTMF_C),
  AudioScheme(3, "DTMF D", AndroidSoundIDs.TONE_DTMF_D),
  AudioScheme(4, "DTMF P", AndroidSoundIDs.TONE_DTMF_P),
  AudioScheme(5, "DTMF S", AndroidSoundIDs.TONE_DTMF_S),
  AudioScheme(6, "DTMF 0", AndroidSoundIDs.TONE_DTMF_0),



];

