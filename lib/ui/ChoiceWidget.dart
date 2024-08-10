import 'package:bdt/ui/utils.dart';
import 'package:flutter/material.dart';

class ChoiceWidgetRow {
  String text;
  TextStyle? style;
  
  ChoiceWidgetRow(this.text, this.style);
}
class ChoiceWidget extends StatefulWidget {
  final List<ChoiceWidgetRow> choices;
  final int? initialSelected;
  final ValueChanged<int> onChanged;

  const ChoiceWidget({required this.choices, this.initialSelected, required this.onChanged});
  
  @override
  _ChoiceWidgetState createState() => _ChoiceWidgetState();
}

class _ChoiceWidgetState extends State<ChoiceWidget> {
  int? _currentSelected;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  @override
  void didUpdateWidget(covariant ChoiceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initState();
  }

  void _initState() {
    _currentSelected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: _buildChoices());
  }

  List<Widget> _buildChoices() {

    return widget.choices.asMap().map((index, choice) => MapEntry(index, SimpleDialogOption(
        onPressed: () {
          setState(() {
            _currentSelected = index;
            widget.onChanged(index);
          });
        },
        child: Row(
          children: [
            createCheckIcon(index == _currentSelected),
            const Spacer(),
            Text(choice.text, style: choice.style),
          ],
        ),
      )
    )).values.toList();
  }

}