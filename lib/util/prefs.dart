import '../service/PreferenceService.dart';

Future<bool> mayNotify(PreferenceService preferenceService) async {
  return await preferenceService.getBool(PreferenceService.PREF_NOTIFY_AT_BREAKS)??true == true;
}

Future<bool> mayVibrate(PreferenceService preferenceService) async {
  return await preferenceService.getBool(PreferenceService.PREF_VIBRATE_AT_BREAKS) == true;
}

Future<bool> shouldSignalTwice(PreferenceService preferenceService) async {
  return await preferenceService.getBool(PreferenceService.PREF_SIGNAL_TWICE) == true;
}

Future<int?> getVolume(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getInt("SIGNAL_VOLUME");
}

setVolume(PreferenceService preferenceService, int volume) async {
  await preferenceService.setInt("SIGNAL_VOLUME", volume);
}

Future<int?> getPinnedBreakDown(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getInt("PINNED_BREAKDOWN");
}

setPinnedBreakDown(PreferenceService preferenceService, int? id) async {
  if (id != null) {
    await preferenceService.setInt("PINNED_BREAKDOWN", id);
  }
  else {
    await preferenceService.remove("PINNED_BREAKDOWN");
  }
}

Future<String?> getRunState(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getString("RUN_STATE");
}

setRunState(PreferenceService preferenceService, String? value) async {
  if (value != null) {
    await preferenceService.setString("RUN_STATE", value);
  }
  else {
    await preferenceService.remove("RUN_STATE");
  }
}

Future<int?> getBreaksCount(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getInt("RUN_BREAKS_COUNT");
}

setBreaksCount(PreferenceService preferenceService, int count) async {
  await preferenceService.setInt("RUN_BREAKS_COUNT", count);
}

Future<int?> getProgress(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return await preferenceService.getInt("RUN_PROGRESS");
}

setProgress(PreferenceService preferenceService, int? progress) async {
  if (progress != null) {
    await preferenceService.setInt("RUN_PROGRESS", progress);
  }
  else {
    await preferenceService.remove("RUN_PROGRESS");
  }
}

Future<DateTime?> getStartedAt(PreferenceService preferenceService) async {
  await preferenceService.reload();
  final startedAtAsEpochMillis = await preferenceService.getInt("RUN_STARTED_AT");
  if (startedAtAsEpochMillis != null) {
    return DateTime.fromMillisecondsSinceEpoch(startedAtAsEpochMillis);
  }
  else {
    return null;
  }
}

setStartedAt(PreferenceService preferenceService, DateTime? startedAt) async {
  if (startedAt != null) {
    await preferenceService.setInt("RUN_STARTED_AT", startedAt.millisecondsSinceEpoch);
  }
  else {
    await preferenceService.remove("RUN_STARTED_AT");
  }
}
