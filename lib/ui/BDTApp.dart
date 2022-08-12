import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:bdt/ui/BDTScaffold.dart';

import '../main.dart';

final PRIMARY_COLOR = Colors.blue[900]!;
final BUTTON_COLOR = Colors.blue;
final ACCENT_COLOR = Colors.blue[50]!;
final FOREGROUND_COLOR = Colors.lightBlue;

class BDTApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: APP_NAME,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,

        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: PRIMARY_COLOR,
            primarySwatch: BUTTON_COLOR,
            backgroundColor: Colors.black,
            scaffoldBackgroundColor: Colors.black,

            appBarTheme: AppBarTheme(
                color: Colors.black,
                foregroundColor: FOREGROUND_COLOR
            )
          // accentColor: Colors.green,

        ),
        themeMode: ThemeMode.dark,

        home: BDTScaffold(),
      ),
    );
  }
}

