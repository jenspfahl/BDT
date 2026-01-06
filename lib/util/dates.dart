import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const ABBREV_HOURS = 'hrs';
const ABBREV_MINUTES = 'min';
const ABBREV_SECONDS = 'sec';

DateTime truncToDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

DateTime truncToMinutes(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
}

DateTime roundToHour(DateTime dateTime) {
  if (dateTime.minute > 0) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour)
        .add(const Duration(hours: 1));
  }
  else {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour);
  }
}



bool isToday(DateTime? dateTime) {
  if (dateTime == null) return false;
  return truncToDate(dateTime) == truncToDate(DateTime.now());
}


String formatDateTime(String languageCode, DateTime dateTime, {bool withLineBreak = false, bool withSeconds = false}) {
  final betweenChar = withLineBreak ? '\n' : ' ';
  final DateFormat dateFormatter = DateFormat.Md(languageCode);
  final DateFormat timeFormatter = withSeconds ? DateFormat.Hms(languageCode) : DateFormat.Hm(languageCode);
  if (isToday(dateTime)) {
    return timeFormatter.format(dateTime);
  }
  else {
    return dateFormatter.format(dateTime) + betweenChar +
        timeFormatter.format(dateTime);
  }
}
String formatTimeOfDay(BuildContext context, TimeOfDay timeOfDay) {

  return timeOfDay.format(context);
 // return "${timeOfDay.hour.toString().padLeft(1, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";
}

String formatDuration(Duration duration, {bool withLineBreak = false, bool noSeconds = false}) {
  final betweenChar = withLineBreak ? '\n' : ' ';
  if (duration.inMinutes >= 60) {
    var remainingMinutes = duration.inMinutes % 60;
    if (remainingMinutes != 0) {
      return '${duration.inHours} $ABBREV_HOURS$betweenChar$remainingMinutes $ABBREV_MINUTES';
    }
    else {
      return '${duration.inHours} $ABBREV_HOURS';
    }
  }
  if (duration.inSeconds >= 60) {
    var remainingSeconds = duration.inSeconds % 60;
    if (!noSeconds && remainingSeconds != 0) {
      return '${duration.inMinutes} min$betweenChar$remainingSeconds $ABBREV_SECONDS';
    }
    else {
      return '${duration.inMinutes} $ABBREV_MINUTES';
    }
  }
  return '${duration.inSeconds} $ABBREV_SECONDS';
}
