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


String formatDuration(Duration duration) {
  if (duration.inMinutes >= 60) {
    var remainingMinutes = duration.inMinutes % 60;
    return "${duration.inHours} hrs\n$remainingMinutes min";
  }
  if (duration.inSeconds >= 60) {
    var remainingSeconds = duration.inSeconds % 60;
    return "${duration.inMinutes} min\n$remainingSeconds sec";
  }
  return "${duration.inSeconds} sec";
}

