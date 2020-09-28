import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyLocalizations {
  MyLocalizations(this.locale);

  final Locale locale;

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  Map<String, String> _localizedValues;

  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString('assets/languages/${locale.languageCode}.json');
    Map<String, dynamic> jsonLanguageMap = json.decode(jsonString);
    _localizedValues = jsonLanguageMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  String getString(String stringName) {
    return _localizedValues[stringName] ?? "MISSING STRING";
  }
}

class MyLocalizationDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) async {
    MyLocalizations localizations = new MyLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(MyLocalizationDelegate old) => false;
}
