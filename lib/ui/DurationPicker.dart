import 'dart:math';

import 'package:bdt/util/dates.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../l10n/app_localizations.dart';
import '../service/ColorService.dart';

class DurationPicker extends StatefulWidget {
  late final int _initialHours;
  late final int _initialMinutes;
  late final int _initialSeconds;
  final ValueChanged<Duration> onChanged;
  late final bool isLandscape;

  DurationPicker({
    Duration? initialDuration,
    required this.onChanged,
    bool? showSeconds,
    required bool isLandscape
  }) {
    this._initialHours = initialDuration?.inHours ?? 0;
    this._initialMinutes = (initialDuration?.inMinutes ?? 0) % 60;
    this._initialSeconds = (initialDuration?.inSeconds ?? 0) % 60;
    this.isLandscape = isLandscape;
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

  bool _showSeconds = false;

  @override
  void initState() {
    super.initState();
    _hours = min(widget._initialHours.abs(), MAX_HOURS);
    _minutes = min(widget._initialMinutes.abs(), MAX_MINUTES);
    _seconds = min(widget._initialSeconds.abs(), MAX_SECONDS);

    _showSeconds = widget._initialSeconds > 0;

  }

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    final hoursPicker = NumberPicker(
      value: _hours,
      minValue: 0,
      maxValue: MAX_HOURS,
      axis: widget.isLandscape ? Axis.horizontal : Axis.vertical,
      selectedTextStyle: TextStyle(
          fontSize: 24,
          color: ColorService()
            .getCurrentScheme()
            .button),
      onChanged: (value) => setState(() {
        _hours = value;
        widget.onChanged(_getSelectedDuration());
      }),
    );
    final minutesPicker = NumberPicker(
      value: _minutes,
      minValue: 0,
      maxValue: MAX_MINUTES,
      axis: widget.isLandscape ? Axis.horizontal : Axis.vertical,
      selectedTextStyle: TextStyle(
          fontSize: 24,
          color: ColorService()
              .getCurrentScheme()
              .button),
      onChanged: (value) => setState(() { 
        _minutes = value;
        widget.onChanged(_getSelectedDuration());
      }),
    );
    final secondsPicker = NumberPicker(
      value: _seconds,
      minValue: 0,
      maxValue: MAX_SECONDS,
      axis: widget.isLandscape ? Axis.horizontal : Axis.vertical,
      selectedTextStyle: TextStyle(
          fontSize: 24,
          color: ColorService()
              .getCurrentScheme()
              .button),
      onChanged: (value) => setState(() {
        _seconds = value;
        widget.onChanged(_getSelectedDuration());
      }),
    );
    //scaffold the full homepage
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: widget.isLandscape
            ? _buildHorizontalPickers(l10n, hoursPicker, minutesPicker, secondsPicker)
            : _buildVerticalPickers(l10n, hoursPicker, minutesPicker, secondsPicker),
        ),
        if (!_showSeconds) TextButton(
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

  Widget _buildVerticalPickers(AppLocalizations l10n, NumberPicker hoursPicker, NumberPicker minutesPicker, NumberPicker secondsPicker) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: [
                Text(l10n.hours, style: const TextStyle(fontSize: 18)),
                const Text(ABBREV_HOURS),
                const Text(''),
                hoursPicker
              ],
            ),
            Column(
              children: [
                Text(l10n.minutes, style: const TextStyle(fontSize: 18)),
                const Text(ABBREV_MINUTES),
                const Text(''),
                minutesPicker,
              ],
            ),
            if (_showSeconds) Column(
              children: [
                Text(l10n.seconds, style: const TextStyle(fontSize: 18)),
                const Text(ABBREV_SECONDS),
                const Text(''),
                secondsPicker,
              ],
            ),

          ],
        );
  }

  Widget _buildHorizontalPickers(AppLocalizations l10n, NumberPicker hoursPicker, NumberPicker minutesPicker, NumberPicker secondsPicker) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildHorizontalChronoUnitRow(l10n.hours, ABBREV_HOURS, hoursPicker),
        _buildHorizontalChronoUnitRow(l10n.minutes, ABBREV_MINUTES, minutesPicker),
        if (_showSeconds)
          _buildHorizontalChronoUnitRow(l10n.seconds, ABBREV_SECONDS, secondsPicker),
      ],
    );
  }

  Widget _buildHorizontalChronoUnitRow(String title, String subTitle, NumberPicker chronoUnitPicker) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
          children: [
            SizedBox(
              width: 140,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18)),
                  Text(subTitle),
                ],
              ),
            ),
            const Text(''),
            chronoUnitPicker
          ],
        ),
    );
  }

  Duration _getSelectedDuration() {
      return Duration(hours: _hours, minutes: _minutes, seconds: _seconds);
  }
}