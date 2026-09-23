import 'package:bdt/ui/BDTScaffold.dart';
import 'package:flutter/foundation.dart';

import '../model/common.dart';
import '../service/PreferenceService.dart';

// These methods are mainly used by background tasks

Future<bool> mayNotify(PreferenceService preferenceService) async {
  return await preferenceService.getBool(PreferenceService.PREF_NOTIFY_AT_BREAKS) == true;
}

Future<bool> mayVibrate(PreferenceService preferenceService) async {
  return await preferenceService.getBool(PreferenceService.PREF_VIBRATE_AT_BREAKS) == true;
}

Future<bool> shouldSignalTwice(PreferenceService preferenceService) async {
  return await preferenceService.getBool(PreferenceService.PREF_SIGNAL_TWICE) == true;
}
Future<bool> shouldSignalWithoutEncodedNumber(PreferenceService preferenceService) async {
  return await preferenceService.getBool(PreferenceService.PREF_SIGNAL_WITHOUT_NUMBER) == true;
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

Future<RunMode?> getRunMode(PreferenceService preferenceService) async {
  await preferenceService.reload();
  final value = await preferenceService.getInt(PreferenceService.STATE_RUN_MODE);
  if (value == null) {
    return null;
  }
  return RunMode.values.firstWhere((v)=> v.index == value);
}

setRunMode(PreferenceService preferenceService, RunMode? runMode) async {
  if (runMode != null) {
    await preferenceService.setInt(PreferenceService.STATE_RUN_MODE, runMode.index);
  }
  else {
    await preferenceService.remove(PreferenceService.STATE_RUN_MODE);
  }
}

Future<int?> getRunRepetition(PreferenceService preferenceService) async {
  await preferenceService.reload();
  return preferenceService.getInt(PreferenceService.STATE_RUN_REPETITION);
}

setRunRepetition(PreferenceService preferenceService, int? repetition) async {
  if (repetition != null) {
    await preferenceService.setInt(PreferenceService.STATE_RUN_REPETITION, repetition);
  }
  else {
    await preferenceService.remove(PreferenceService.STATE_RUN_REPETITION);
  }
}

Future<Direction?> getRunDirection(PreferenceService preferenceService) async {
  await preferenceService.reload();
  final value = await preferenceService.getInt(PreferenceService.STATE_RUN_DIRECTION);
  if (value == null) {
    return null;
  }
  return Direction.values.firstWhere((v)=> v.index == value);
}

setRunDirection(PreferenceService preferenceService, Direction direction) async {
  await preferenceService.setInt(PreferenceService.STATE_RUN_DIRECTION, direction.index);
}

Future<int?> getProgress(PreferenceService preferenceService, int currentIndex, bool isFinished) async {
  await preferenceService.reload();
  final direction = await getRunDirection(preferenceService);
  if (isFinished) {
    if (direction == null || direction == Direction.ASC) {
      return MAX_SLICE;
    }
    else {
      return 0;
    }
  }

  final progressPath = await preferenceService.getString(PreferenceService.STATE_RUN_PROGRESS_PATH);
  debugPrint('use progressPath=$progressPath and index=$currentIndex');

  if (progressPath == null) {
    return null;
  }
  final split = progressPath.split(',');
  if (split.isEmpty || currentIndex < 0 || currentIndex > split.length - 1 ) {
    return null;
  }

  if (direction == null || direction == Direction.ASC) {
    final value = int.tryParse(split[currentIndex]);
    debugPrint('path value=$value');
    if (value == null) {
      return null;
    }

    return value;
  }
  else {
    final value = int.tryParse(split[split.length - 1 - currentIndex]);
    debugPrint('path value=$value for idx=${split.length - 1 - currentIndex}');
    if (value == null) {
      return null;
    }

    return MAX_SLICE - value;
  }
}

Future<List<int>> getProgressPath(PreferenceService preferenceService) async {
  final progressPath = await preferenceService.getString(PreferenceService.STATE_RUN_PROGRESS_PATH);

  if (progressPath == null) {
    return [];
  }
  final split = progressPath.split(',');
  if (split.isEmpty) {
    return [];
  }

  return split.map((e) => int.tryParse(e)).nonNulls.toList();

}

setProgressPath(PreferenceService preferenceService, String? path) async {
  if (path != null) {
    await preferenceService.setString(PreferenceService.STATE_RUN_PROGRESS_PATH, path);
  }
  else {
    await preferenceService.remove(PreferenceService.STATE_RUN_PROGRESS_PATH);
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

Future<Duration?> getDuration(PreferenceService preferenceService) async {
  await preferenceService.reload();
  final durationInSeconds = await preferenceService.getInt(PreferenceService.STATE_RUN_DURATION);
  if (durationInSeconds != null) {
    return Duration(seconds: durationInSeconds);
  }
  else {
    return null;
  }
}

setDuration(PreferenceService preferenceService, Duration? duration) async {
  if (duration != null) {
    await preferenceService.setInt(PreferenceService.STATE_RUN_DURATION, duration.inSeconds);
  }
  else {
    await preferenceService.remove(PreferenceService.STATE_RUN_DURATION);
  }
}
