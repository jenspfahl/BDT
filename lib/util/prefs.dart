import '../service/PreferenceService.dart';

Future<bool> mayNotify(PreferenceService preferenceService) async {
  return await preferenceService.getBool(PreferenceService.PREF_NOTIFY_AT_BREAKS) == true;
}

Future<bool> mayVibrate(PreferenceService preferenceService) async {
  return await preferenceService.getBool(PreferenceService.PREF_VIBRATE_AT_BREAKS) == true;
}

Future<bool> shouldSignalTwice(PreferenceService preferenceService) async {
  return await preferenceService.getBool(PreferenceService.PREF_SIGNAL_TWICE) == true;
}

Future<bool> shouldCancelSignalling(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getBool(PreferenceService.STATE_SIGNAL_CANCELLING) == true;
}

Future<int?> getCurrentSignalling(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getInt(PreferenceService.STATE_SIGNAL_PROCESSING);
}

initCurrentSignalling(PreferenceService preferenceService, int id) async {
  await preferenceService.setInt(PreferenceService.STATE_SIGNAL_PROCESSING, id);
}

Future<int> getVolume(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getInt(PreferenceService.PREF_SIGNAL_VOLUME) ?? PreferenceService.PREF_SIGNAL_VOLUME.defaultValue;
}

setVolume(PreferenceService preferenceService, int volume) async {
  await preferenceService.setInt(PreferenceService.PREF_SIGNAL_VOLUME, volume);
}

Future<int?> getPinnedBreakDown(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getInt(PreferenceService.DATA_PINNED_BREAK_DOWN);
}

setPinnedBreakDown(PreferenceService preferenceService, int? id) async {
  if (id != null) {
    await preferenceService.setInt(PreferenceService.DATA_PINNED_BREAK_DOWN, id);
  }
  else {
    await preferenceService.remove(PreferenceService.DATA_PINNED_BREAK_DOWN);
  }
}

Future<String?> getRunState(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getString(PreferenceService.STATE_RUN_STATE);
}

setRunState(PreferenceService preferenceService, String? value) async {
  if (value != null) {
    await preferenceService.setString(PreferenceService.STATE_RUN_STATE, value);
  }
  else {
    await preferenceService.remove(PreferenceService.STATE_RUN_STATE);
  }
}

Future<int?> getBreaksCount(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getInt(PreferenceService.STATE_RUN_BREAKS_COUNT);
}

setBreaksCount(PreferenceService preferenceService, int count) async {
  await preferenceService.setInt(PreferenceService.STATE_RUN_BREAKS_COUNT, count);
}

Future<int?> getProgress(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getInt(PreferenceService.STATE_RUN_PROGRESS);
}

setProgress(PreferenceService preferenceService, int? progress) async {
  if (progress != null) {
    await preferenceService.setInt(PreferenceService.STATE_RUN_PROGRESS, progress);
  }
  else {
    await preferenceService.remove(PreferenceService.STATE_RUN_PROGRESS);
  }
}

Future<DateTime?> getStartedAt(PreferenceService preferenceService) async {
  await preferenceService.reload();
  final startedAtAsEpochMillis = await preferenceService.getInt(PreferenceService.STATE_RUN_STARTED_AT);
  if (startedAtAsEpochMillis != null) {
    return DateTime.fromMillisecondsSinceEpoch(startedAtAsEpochMillis);
  }
  else {
    return null;
  }
}

setStartedAt(PreferenceService preferenceService, DateTime? startedAt) async {
  if (startedAt != null) {
    await preferenceService.setInt(PreferenceService.STATE_RUN_STARTED_AT, startedAt.millisecondsSinceEpoch);
  }
  else {
    await preferenceService.remove(PreferenceService.STATE_RUN_STARTED_AT);
  }
}
