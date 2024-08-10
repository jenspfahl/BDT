import 'package:flutter/material.dart';

import '../service/ColorService.dart';

class VolumeSliderDialog extends StatefulWidget {
  final double initialSelection;
  final Function(double)? onChangedEnd;

  const VolumeSliderDialog({Key? key,
    required this.initialSelection,
    this.onChangedEnd,
  }) : super(key: key);

  @override
  _VolumeSliderDialogState createState() => _VolumeSliderDialogState();
}

class _VolumeSliderDialogState extends State<VolumeSliderDialog> {
  late double _currentValue;
  double? _oldValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    final titleText = Text("Volume : ${_currentValue == 0 ? "-muted-" : _currentValue.toInt().toString() + "%" }");
    return AlertDialog(
      alignment: Alignment.centerRight,
      shape: const RoundedRectangleBorder(),
      title: Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                child: createVolumeIcon(_currentValue.round()),
              ),
              titleText
            ],),
      content: Container(
        child: Column(
          children: [
            Expanded(
              child: RotatedBox(
                quarterTurns: -1,
                child: Slider(
                  value: _currentValue,
                  min: 0,
                  max: MAX_VOLUME.toDouble(),
                  divisions: 20,
                  activeColor: ColorService().getCurrentScheme().button,
                  thumbColor: ColorService().getCurrentScheme().accent,
                  onChanged: (value) {
                    setState(() {
                      _currentValue = value;
                    });
                  },
                  onChangeEnd: widget.onChangedEnd,
                ),
              ),
            ),
            SwitchListTile(
              activeColor: ColorService().getCurrentScheme().button,
              hoverColor: ColorService().getCurrentScheme().accent,
              value: _currentValue == 0,
              title: const Text('Mute'),
              onChanged: (value) {
                setState(() {
                  if (value) {
                    _oldValue = _currentValue;
                    _currentValue = 0;
                  }
                  else {
                    _currentValue = _oldValue ?? MAX_VOLUME.toDouble();
                  }
                  if (widget.onChangedEnd != null) {
                    widget.onChangedEnd!(_currentValue);
                  }
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Use the second argument of Navigator.pop(...) to pass
            // back a result to the page that opened the dialog
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Use the second argument of Navigator.pop(...) to pass
            // back a result to the page that opened the dialog
            Navigator.pop(context, _currentValue);
          },
          child: const Text('Ok'),
        )
      ],
    );
  }

}

int MAX_VOLUME = 100;

Icon createVolumeIcon(int volume) {
  return Icon(volume == 0
      ? Icons.volume_mute
      : volume <= 50 ? Icons.volume_down_rounded : Icons.volume_up_rounded);
}