import 'package:flutter/material.dart';

import 'BDTApp.dart';



String truncate(String text, { required int length, omission: '...' }) {
  if (length >= text.length) {
    return text;
  }
  return text.replaceRange(length, text.length, omission);
}

Widget createCheckIcon(bool checked) {
  if (!checked) {
    return Text("");
  }
  return Icon(
    Icons.check,
    color: BUTTON_COLOR,
  );
}

toastInfo(BuildContext context, String message) {
  _calcMessageDuration(message, false).then((duration) {
    var messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
        SnackBar(
            duration: duration,
            content: Text(message)));
  });
}

toastError(BuildContext context, String message) {
  _calcMessageDuration(message, true).then((duration) {
    var messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            duration: duration,
            content: Text(message)));
  });
}

Future<Duration> _calcMessageDuration(String message, bool isError) async {
  return Duration(milliseconds: (message.length * (isError ? 100 : 80)).toInt());
}