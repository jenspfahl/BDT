import '../service/PreferenceService.dart';

Future<bool> canNotify(PreferenceService preferenceService) async {
  return await preferenceService.getBool("CAN_NOTIFY") == true;
}

Future<bool> canSignal(PreferenceService preferenceService) async {
  return await preferenceService.getBool("CAN_SIGNAL") == true;
}

Future<int?> getVolume(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getInt("SIGNAL_VOLUME");
}

setVolume(PreferenceService preferenceService, int volume) async {
  await preferenceService.setInt("SIGNAL_VOLUME", volume);
}
