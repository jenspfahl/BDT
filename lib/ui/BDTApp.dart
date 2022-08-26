import 'dart:async';

import 'package:bdt/service/ColorService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:bdt/ui/BDTScaffold.dart';

import '../main.dart';

StreamController<int> colorSchemeController = StreamController();

class BDTApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: StreamBuilder<int>(
        stream: colorSchemeController.stream,
        builder: (context, snapshot) {
          return MaterialApp(
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
                primaryColor: ColorService().getCurrentScheme().primary,
                primarySwatch: ColorService().getCurrentScheme().button,
                backgroundColor: ColorService().getCurrentScheme().background,
                scaffoldBackgroundColor: ColorService().getCurrentScheme().background,

                appBarTheme: AppBarTheme(
                    color: Colors.black,
                    foregroundColor: ColorService().getCurrentScheme().foreground,
                )
              // accentColor: Colors.green,

            ),
            themeMode: ThemeMode.dark,

            home: BDTScaffold(),
          );
        }
      ),
    );
  }
}

