import 'package:dc_community_app/localization.dart';
import 'package:dc_community_app/screens/home_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constants.dart';

void main() => runApp(
      DevicePreview(
        enabled: false, //!kReleaseMode,
        builder: (context) => MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.of(context).locale,
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Constants.primaryColor,
          accentColor: Constants.accentColor,
          fontFamily: Constants.fontFamily),
      onGenerateTitle: (BuildContext context) =>
          MyLocalizations.of(context).getString("pageTitle"),
      localizationsDelegates: [
        const MyLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      supportedLocales: [const Locale('en', 'US')],
      home: HomeScreen(),
    );
  }
}
