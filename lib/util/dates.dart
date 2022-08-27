import 'package:intl/intl.dart';

DateTime fillToWholeDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 9999);
}

DateTime truncToDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

DateTime truncToMinutes(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
}

DateTime roundToHour(DateTime dateTime) {
  if (dateTime.minute > 0) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour)
        .add(Duration(hours: 1));
  }
  else {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour);
  }
}

DateTime roundToMinute(DateTime dateTime) {
  if (dateTime.second > 0) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute)
        .add(Duration(minutes: 1));
  }
  else {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
  }
}

bool isTomorrow(DateTime? dateTime) {
  if (dateTime == null) return false;
  return truncToDate(dateTime) == truncToDate(DateTime.now().add(Duration(days: 1)));
}

bool isToday(DateTime? dateTime) {
  if (dateTime == null) return false;
  return truncToDate(dateTime) == truncToDate(DateTime.now());
}

bool isYesterday(DateTime? dateTime) {
  if (dateTime == null) return false;
  return truncToDate(dateTime) == truncToDate(DateTime.now().subtract(Duration(days: 1)));
}

String formatToDateTime(DateTime dateTime, {bool withLineBreak = false, bool withSeconds = false}) {
  final betweenChar = withLineBreak ? "\n" : " ";
  final DateFormat dateFormatter = DateFormat.yM();
  final DateFormat timeFormatter = withSeconds ? DateFormat.Hms() : DateFormat.Hm();
  if (isToday(dateTime)) {
    return timeFormatter.format(dateTime);
  }
  else {
    return dateFormatter.format(dateTime) + betweenChar +
        timeFormatter.format(dateTime);
  }
}

String formatDuration(Duration duration, {bool withLineBreak = false, bool noSeconds = false}) {
  final betweenChar = withLineBreak ? "\n" : " ";
  if (duration.inMinutes >= 60) {
    var remainingMinutes = duration.inMinutes % 60;
    if (remainingMinutes != 0) {
      return "${duration.inHours} hrs$betweenChar$remainingMinutes min";
    }
    else {
      return "${duration.inHours} hrs";
    }
  }
  if (duration.inSeconds >= 60) {
    var remainingSeconds = duration.inSeconds % 60;
    if (!noSeconds && remainingSeconds != 0) {
      return "${duration.inMinutes} min$betweenChar$remainingSeconds sec";
    }
    else {
      return "${duration.inMinutes} min";
    }
  }
  return "${duration.inSeconds} sec";
}

