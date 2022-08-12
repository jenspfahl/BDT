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

String formatToDateTime(DateTime dateTime) {
  final DateFormat dateFormatter = DateFormat.yMd();
  final DateFormat timeFormatter = DateFormat.Hms();
  return dateFormatter.format(dateTime) + " " + timeFormatter.format(dateTime);
}

String formatToTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat.Hms();
  return formatter.format(dateTime);
}


String formatDuration(Duration duration, {bool withLineBreak = false}) {
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
    if (remainingSeconds != 0) {
      return "${duration.inMinutes} min$betweenChar$remainingSeconds sec";
    }
    else {
      return "${duration.inMinutes} min";
    }
  }
  return "${duration.inSeconds} sec";
}

