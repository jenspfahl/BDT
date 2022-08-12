import 'package:bdt/ui/BDTApp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO under construction
class HoldOnButton extends StatefulWidget {

  Icon buttonIcon;

  HoldOnButton(this.buttonIcon);

  @override
  _HoldOnButtonState createState() => _HoldOnButtonState();
}

class _HoldOnButtonState extends State<HoldOnButton> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) {
        if (_animationController.status == AnimationStatus.forward) {
          _animationController.reverse();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 32,
            valueColor: AlwaysStoppedAnimation<Color>(BUTTON_COLOR),
          ),
          CircularProgressIndicator(
            value: _animationController.value,
            strokeWidth: 32,
            valueColor: AlwaysStoppedAnimation<Color>(ACCENT_COLOR),
          ),
          widget.buttonIcon
        ],
      ),
    );
  }
}