import 'package:bdt/service/ColorService.dart';
import 'package:bdt/ui/VolumeSliderDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:open_settings/open_settings.dart';

import '../main.dart';
import '../service/PreferenceService.dart';
import 'ChoiceWidget.dart';
import 'DurationPicker.dart';


void showConfirmationDialog(BuildContext context, String title, String message,
    {Icon? icon, Function()? okPressed, Function()? cancelPressed}) {

  List<Widget> actions = [];
  if (cancelPressed != null) {
    Widget cancelButton = TextButton(
      child: Text(translate('common.cancel')),
      onPressed:  cancelPressed,
    );
    actions.add(cancelButton);
  }
  if (okPressed != null) {
    Widget okButton = TextButton(
      child: Text(translate('common.ok')),
      onPressed:  okPressed,
    );
    actions.add(okButton);
  }
  AlertDialog alert = AlertDialog(
    title: icon != null
      ? Row(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
        child: icon,
      ),
      Text(title)
    ],)
      : Text(title),
    content: Text(message),
    actions: actions,
  );  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showInputWithSwitchDialog(BuildContext context, String title, String message,
    {Icon? icon,
      String? initText,
      String? hintText,
      String? switchText,
      required ValueNotifier<bool> isSwitched,
      String? Function(String?)? validator,
      Function(String)? okPressed,
      Function()? cancelPressed,
    }) {

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final _textFieldController = TextEditingController(text: initText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: icon != null
              ? Row(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
              child: icon,
            ),
            Text(title)
          ],)
              : Text(title),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _textFieldController,
                          decoration: InputDecoration(hintText: hintText),
                          maxLength: 50,
                          keyboardType: TextInputType.text,
                          validator: validator,
                          autovalidateMode: AutovalidateMode.onUserInteraction
                        ),
                      ),
                      IconButton(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          constraints: const BoxConstraints(),
                          onPressed: () => _textFieldController.clear(),
                          icon: const Icon(Icons.clear_outlined))
                    ],
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: isSwitched,
                    builder: (context, currentState, child) {
                      return SwitchListTile(
                        activeColor: ColorService().getCurrentScheme().button,
                        value: isSwitched.value,
                        title: Text(switchText??''),
                        onChanged: (value) {
                          isSwitched.value = value;
                        },
                      );
                    }),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(translate('common.cancel')),
              onPressed: cancelPressed
            ),
            TextButton(
              child: Text(translate('common.ok')),
              onPressed: () {
                if (okPressed != null && _formKey.currentState!.validate()) {
                  okPressed(_textFieldController.text);
                }
              },
            ),
          ],
        );
      },
    );
}

Future<double?> showVolumeSliderDialog(BuildContext context, {Key? key,
  required double initialSelection,
  Function(double)? onChangedEnd,
}) {
  return showDialog<double>(
    context: context,
    builder: (context) => VolumeSliderDialog(
      initialSelection: initialSelection,
      onChangedEnd: onChangedEnd,
    )
  );
}

Future<bool?> showDurationPickerDialog({
  required BuildContext context,
  Duration? initialDuration,
  required ValueChanged<Duration> onChanged,
}) {

  final durationPicker = DurationPicker(
      initialDuration: initialDuration,
      onChanged: onChanged,
  );

  Dialog dialog = Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)), //this right here
    child: Container(
      height: 300.0,
      width: 300.0,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          durationPicker,
          const SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            TextButton(
              child: Text(translate('common.cancel')),
              onPressed:  () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(translate('common.ok')),
              onPressed:  () => Navigator.of(context).pop(true),
            )
            ],)
        ],
      ),
    ),
  );

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}


Future<void> showChoiceDialog(BuildContext context, String title, List<ChoiceWidgetRow> choices, {
  Function()? okPressed,
  Function()? cancelPressed,
  int? initialSelected,
  required ValueChanged<int> selectionChanged
}) {
  Widget cancelButton = TextButton(
    child: Text(translate('common.cancel')),
    onPressed:  cancelPressed,
  );
  Widget okButton = TextButton(
    child: Text(translate('common.ok')),
    onPressed:  okPressed,
  );

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ChoiceWidget(
              choices: choices,
              initialSelected: initialSelected,
              onChanged: selectionChanged,
            ),
          ),
          actions: [
            cancelButton,
            okButton,
          ],
        );
      }
  );
}



showBatterySavingHint(BuildContext context, PreferenceService preferenceService) {
  AlertDialog alert = AlertDialog(
    title: const Text(APP_NAME),
    content: Text("To schedule exact alarms, this app should be exempted from any battery optimizations. Is scheduling not working properly, you should exempt it. Open the settings, and enable exemption ('not optimized') for '$APP_NAME'."),
    actions: [
      TextButton(
        child: Text(translate('batterySavings.openSettings')),
        onPressed:  () {
          Navigator.pop(context);
          OpenSettings.openIgnoreBatteryOptimizationSetting();
        },
      ),
      TextButton(
        child: Text(translate('batterySavings.dontAskAgain')),
        onPressed:  () {
          Navigator.pop(context);
          preferenceService.setBool(PreferenceService.DATA_BATTERY_SAVING_RESTRICTIONS_HINT_DISMISSED, true);
        },
      ),
    ],
  );  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<dynamic> showPopUpMenuAtTapDown(BuildContext context, TapDownDetails tapDown, List<PopupMenuEntry> items) {
  return showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      tapDown.globalPosition.dx,
      tapDown.globalPosition.dy,
      tapDown.globalPosition.dx,
      tapDown.globalPosition.dy,
    ),
    items: items,
    elevation: 8.0,
  );
}



