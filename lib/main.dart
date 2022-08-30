import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:bdt/service/LocalNotificationService.dart';
import 'package:bdt/service/PreferenceService.dart';

import 'ui/BDTApp.dart';

const String APP_NAME = "Break.Down.Timer";
const String APP_NAME_SHORT = "B.D.T";

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotificationService().init();
  await AndroidAlarmManager.initialize();
  await PreferenceService().init();

  var delegate = await LocalizationDelegate.create(
    preferences: PreferenceService(),
    fallbackLocale: 'en',
    supportedLocales: ['en']);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(LocalizedApp(delegate, BDTApp()));
  });

}


