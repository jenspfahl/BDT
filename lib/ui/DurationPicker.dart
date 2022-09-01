import 'dart:math';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class DurationPicker extends StatefulWidget {
  late final int _initialHours;
  late final int _initialMinutes;
  final ValueChanged<Duration> onChanged;

  DurationPicker({
    Duration? initialDuration,
    required this.onChanged
  }) {
    this._initialHours = initialDuration?.inHours ?? 0;
    this._initialMinutes = (initialDuration?.inMinutes ?? 0) % 60;
  }
  
  @override
  _DurationPickerState createState() {
    return _DurationPickerState();
  }

}

class _DurationPickerState extends State<DurationPicker> {
  final MAX_HOURS = 23;
  final MAX_MINUTES = 59;

  int _hours = 0;
  int _minutes = 0;

  @override
  void initState() {
    super.initState();
    _hours = min(widget._initialHours.abs(), MAX_HOURS);
    _minutes = min(widget._initialMinutes.abs(), MAX_MINUTES);
  }

  @override
  Widget build(BuildContext context) {
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
    //scaffold the full homepage
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: [
            Text('hours'),
            hoursPicker
          ],
        ),
        Column(
          children: [
            Text('minutes'),
            minutesPicker,
          ],
        ),
      ],
    );
  }

  Duration _getSelectedDuration() {
      return Duration(hours: _hours, minutes: _minutes);
  }
}