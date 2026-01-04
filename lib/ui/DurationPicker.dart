import 'dart:math';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../l10n/app_localizations.dart';

class DurationPicker extends StatefulWidget {
  late final int _initialHours;
  late final int _initialMinutes;
  late final int _initialSeconds;
  final ValueChanged<Duration> onChanged;
  bool? _showSeconds;

  DurationPicker({
    Duration? initialDuration,
    required this.onChanged,
    bool? showSeconds
  }) {
    this._initialHours = initialDuration?.inHours ?? 0;
    this._initialMinutes = (initialDuration?.inMinutes ?? 0) % 60;
    this._initialSeconds = (initialDuration?.inSeconds ?? 0) % 60;
    this._showSeconds = showSeconds;
  }
  
  @override
  _DurationPickerState createState() {
    return _DurationPickerState();
  }

}

class _DurationPickerState extends State<DurationPicker> {
  final MAX_HOURS = 23;
  final MAX_MINUTES = 59;
  final MAX_SECONDS = 59;

  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  bool? _showSeconds;

  @override
  void initState() {
    super.initState();
    _hours = min(widget._initialHours.abs(), MAX_HOURS);
    _minutes = min(widget._initialMinutes.abs(), MAX_MINUTES);
    _seconds = min(widget._initialSeconds.abs(), MAX_SECONDS);

    this._showSeconds = widget._showSeconds ?? widget._initialSeconds > 0 && widget._initialHours < 1;

  }

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    final hoursPicker = NumberPicker(
      value: _hours,
      minValue: 0,
      maxValue: MAX_HOURS,
      onChanged: (value) => setState(() { 
        _hours = value;
        widget.onChanged(_getSelectedDuration());
      }),
    );
    final minutesPicker = NumberPicker(
      value: _minutes,
      minValue: 0,
      maxValue: MAX_MINUTES,
      onChanged: (value) => setState(() { 
        _minutes = value;
        widget.onChanged(_getSelectedDuration());
      }),
    );
    final secondsPicker = NumberPicker(
      value: _seconds,
      minValue: 0,
      maxValue: MAX_SECONDS,
      onChanged: (value) => setState(() {
        _seconds = value;
        widget.onChanged(_getSelectedDuration());
      }),
    );
    //scaffold the full homepage
    return Column(
      children: [
        Row(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: [
                Text(l10n.hours),
                hoursPicker
              ],
            ),
            Column(
              children: [
                Text(l10n.minutes),
                minutesPicker,
              ],
            ),
            if (_showSeconds == true) Column(
              children: [
                Text(l10n.seconds),
                secondsPicker,
              ],
            ),

          ],
        ),
        if (_showSeconds != true) TextButton(
          child: Text('${l10n.changeSeconds} >>>'),
          onPressed:  () {
            setState(() {
              _showSeconds = true;
            });
          },
        ),
      ],
    );
  }

  Duration _getSelectedDuration() {
      return Duration(hours: _hours, minutes: _minutes, seconds: _seconds);
  }
}