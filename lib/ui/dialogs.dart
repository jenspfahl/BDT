import 'package:bdt/service/ColorService.dart';
import 'package:bdt/ui/BDTScaffold.dart';
import 'package:bdt/ui/VolumeSliderDialog.dart';
import 'package:bdt/util/dates.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:open_settings/open_settings.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../service/PreferenceService.dart';
import 'ChoiceWidget.dart';
import 'DurationPicker.dart';


void showConfirmationDialog(BuildContext context, String title, String message,
    {Icon? icon, Function()? okPressed, Function()? cancelPressed}) {

  final l10n = AppLocalizations.of(context)!;

  List<Widget> actions = [];
  if (cancelPressed != null) {
    Widget cancelButton = TextButton(
      child: Text(l10n.cancel),
      onPressed:  cancelPressed,
    );
    actions.add(cancelButton);
  }
  if (okPressed != null) {
    Widget okButton = TextButton(
      child: Text(l10n.ok),
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

    final l10n = AppLocalizations.of(context)!;

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
              child: Text(l10n.cancel),
              onPressed: cancelPressed
            ),
            TextButton(
              child: Text(l10n.ok),
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

  final l10n = AppLocalizations.of(context)!;

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
              child: Text(l10n.cancel),
              onPressed:  () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(l10n.ok),
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


Future<int?> showBreakDownDialog({
  required int initialValue,
  required Duration duration,
  required BuildContext context,
}) {

  int _breakCount = initialValue;

  final l10n = AppLocalizations.of(context)!;

  Dialog dialog = Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)), //this right here
    child: Container(
      height: 360.0,
      width: 300.0,

      child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: ImageIcon(AssetImage('assets/launcher_bdt_adaptive_fore.png')),
                        ),
                        const Text('   '),
                        Text(l10n.splitBreaks, style: const TextStyle(fontSize: 18))
                      ]),
                ),
                Text(l10n.splitBreaksDescription(formatDuration(duration))),
                const Text(''),
                Text(l10n.durationBetweenBreaks(_breakCount, formatDuration(_calculateDistance(_breakCount, duration)))),
                Center(
                  child: NumberPicker(
                    value: _breakCount,
                    minValue: 1,
                    maxValue: MAX_BREAKS,
                    onChanged: (value) => setState(() {
                      _breakCount = value;
                    }),
                  ),
                ),

                const SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  TextButton(
                    child: Text(l10n.cancel),
                    onPressed:  () => Navigator.of(context).pop(null),
                  ),
                  TextButton(
                    child: Text(l10n.ok),
                    onPressed:  () => Navigator.of(context).pop(_breakCount),
                  )
                  ],)
              ],
            ),
          );
        }
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

Duration _calculateDistance(int breakCount, Duration duration) {
  double perSlice = MAX_SLICE / (breakCount + 1);
  return Duration(seconds: ((duration.inSeconds / MAX_SLICE) * perSlice).round());
}



Future<void> showChoiceDialog(BuildContext context, String title, List<ChoiceWidgetRow> choices, {
  Function()? okPressed,
  Function()? cancelPressed,
  int? initialSelected,
  required ValueChanged<int> selectionChanged
}) {

  final l10n = AppLocalizations.of(context)!;

  Widget cancelButton = TextButton(
    child: Text(l10n.cancel),
    onPressed:  cancelPressed,
  );
  Widget okButton = TextButton(
    child: Text(l10n.ok),
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
  final l10n = AppLocalizations.of(context)!;

  AlertDialog alert = AlertDialog(
    title: const Text(APP_NAME),
    content: Text(l10n.batterySavingsHint(APP_NAME)),
    actions: [
      TextButton(
        child: Text(l10n.openSettings),
        onPressed:  () {
          Navigator.pop(context);
          OpenSettings.openIgnoreBatteryOptimizationSetting();
        },
      ),
      TextButton(
        child: Text(l10n.dontAskAgain),
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



