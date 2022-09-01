import 'package:flutter/material.dart';

import '../service/ColorService.dart';



String truncate(String text, { required int length, omission: '...' }) {
  if (length >= text.length) {
    return text;
  }
  return text.replaceRange(length, text.length, omission);
}

Widget createCheckIcon(bool checked) {
  if (!checked) {
    return Text('');
  }
  return Icon(
    Icons.check,
    color: ColorService().getCurrentScheme().button,
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