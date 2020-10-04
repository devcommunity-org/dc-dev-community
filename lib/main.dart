import 'package:dc_community_app/screens/home_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_gen/gen_l10n/app_localizations.dart'; //doesn't work yet.

import 'constants.dart';
import 'l10n/generated/app_localizations.dart';

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
          AppLocalizations.of(context).pageTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(),
    );
  }
}
