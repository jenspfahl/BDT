import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderDialog extends StatefulWidget {
  final String? title;
  final int? divisions;
  final double min;
  final double max;
  final double initialSelection;

  const SliderDialog({Key? key,
    this.title,
    required this.initialSelection,
    required this.min,
    required this.max,
    this.divisions,
  }) : super(key: key);

  @override
  _SliderDialogState createState() => _SliderDialogState();
}

class _SliderDialogState extends State<SliderDialog> {
  late double _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title != null ? Text("${widget.title!} : ${_current.toInt()}%") : null,
      content: Container(
        child: RotatedBox(
          quarterTurns: -1,
          child: Slider(
            value: _current,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            onChanged: (value) {
              setState(() {
                _current = value;
              });
            },
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Use the second argument of Navigator.pop(...) to pass
            // back a result to the page that opened the dialog
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Use the second argument of Navigator.pop(...) to pass
            // back a result to the page that opened the dialog
            Navigator.pop(context, _current);
          },
          child: Text('Ok'),
        )
      ],
    );
  }
}