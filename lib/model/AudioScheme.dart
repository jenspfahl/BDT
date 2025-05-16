
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

const DEFAULT_AUDIO_SCHEME_ID = 2; //TONE_DTMF_D

List<AudioScheme> predefinedAudioSchemes = [
  AudioScheme(0, 'Peep A', AndroidSoundIDs.TONE_DTMF_1),
  AudioScheme(1, 'Peep B', AndroidSoundIDs.TONE_DTMF_5),
  AudioScheme(2, 'Peep C', AndroidSoundIDs.TONE_DTMF_9),
  AudioScheme(3, 'Peep D', AndroidSoundIDs.TONE_DTMF_D),
  AudioScheme(4, 'Beep', AndroidSoundIDs.TONE_SUP_DIAL),
  AudioScheme(5, 'Ring', AndroidSoundIDs.TONE_CDMA_NETWORK_USA_RINGBACK),
  AudioScheme(6, 'Siren', AndroidSoundIDs.TONE_SUP_INTERCEPT),
  AudioScheme(7, 'Tweet', AndroidSoundIDs.TONE_CDMA_CALL_SIGNAL_ISDN_NORMAL),
  AudioScheme(8, 'Chirp High', AndroidSoundIDs.TONE_CDMA_HIGH_SS_2),
  AudioScheme(9, 'Chirp Low', AndroidSoundIDs.TONE_CDMA_LOW_L),


];

