import 'dart:async';

import 'package:bdt/service/ColorService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bdt/ui/BDTScaffold.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../service/PreferenceService.dart';

StreamController<dynamic> prefsUpdatedNotifier = StreamController();

class BDTApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return AppBuilder(builder: (context) {
      return StreamBuilder<dynamic>(
          stream: prefsUpdatedNotifier.stream,
          builder: (context, snapshot) {
            return MaterialApp(
              title: APP_NAME_SHORT,
              localizationsDelegates: [
                AppLocalizations.delegate, // use  flutter gen-l10n if you add new languages
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(
                  useMaterial3: false,
                  brightness: Brightness.light,
                  primaryColor: ColorService()
                      .getCurrentScheme()
                      .primary,
                  primarySwatch: ColorService()
                      .getCurrentScheme()
                      .button,
                  scaffoldBackgroundColor: ColorService()
                      .getCurrentScheme()
                      .background,

                  appBarTheme: AppBarTheme(
                    color: ColorService()
                        .getCurrentScheme()
                        .background,
                    foregroundColor: ColorService()
                        .getCurrentScheme()
                        .foreground,
                  )
                // accentColor: Colors.green,
              ),
              darkTheme: ThemeData(
                  useMaterial3: false,
                  brightness: Brightness.dark,
                  primaryColor: ColorService()
                      .getCurrentScheme()
                      .primary,
                  primarySwatch: ColorService()
                      .getCurrentScheme()
                      .button,
                  scaffoldBackgroundColor: ColorService()
                      .getCurrentScheme()
                      .background,

                  appBarTheme: AppBarTheme(
                    color: ColorService()
                        .getCurrentScheme()
                        .background,
                    foregroundColor: ColorService()
                        .getCurrentScheme()
                        .foreground,
                  )
                // accentColor: Colors.green,
              ),
              themeMode: PreferenceService().darkTheme
                  ? ThemeMode.dark
                  : ThemeMode.light,

              home: BDTScaffold(),
            );
          }
      );
    });
  }
}


// from https://hillel.dev/2018/08/15/flutter-how-to-rebuild-the-entire-app-to-change-the-theme-or-locale/
class AppBuilder extends StatefulWidget {
  final Function(BuildContext) builder;

  const AppBuilder(
      {Key? key, required this.builder})
      : super(key: key);

  @override
  AppBuilderState createState() => new AppBuilderState();

  static AppBuilderState? of(BuildContext context) {
    return context.findAncestorStateOfType<AppBuilderState>();
  }
}

class AppBuilderState extends State<AppBuilder> {

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void rebuild() {
    setState(() {});
  }


}
