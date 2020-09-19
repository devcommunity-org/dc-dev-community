import 'package:dc_community_app/localization.dart';
import 'package:dc_community_app/screens/home_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      color: Color(0xffe7ebee),
      theme: ThemeData(
          primaryColor: Color(0xFF3A93F7),
          accentColor: Color(0xFF50AD32),
          fontFamily: "Open Sans"),
      onGenerateTitle: (BuildContext context) =>
          MyLocalizations.of(context).getString("pageTitle"),
      localizationsDelegates: [
        const MyLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en', '')],
      home: HomeScreen(),
    );
  }
}
