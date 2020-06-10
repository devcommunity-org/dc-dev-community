import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class MyLocalizations {
  MyLocalizations(this.locale);

  final Locale locale;

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'pageTitle': 'Dev Community',
      "aboutUs": "About Us",
      "volunteerToSpeak": "Volunteer to Speak",
      "contribute": "Contribute",
      "homeBodyText":
          "Welcome to Dev Community! We are a family of meetups that span a wide variety of tech disciplines, including mobile, web, and cloud development. Check out our upcoming meetups, and volunteer to speak - we are always looking for fresh faces and ideas!",
      "upcomingMeetups": "Upcoming Meetups",
      "featuredVideo": "Featured Video",
      "volunteerToSpeak": "Volunteer to Speak",
      "twitterHandle": "@DevCommunityOrg",
      "videos": "YouTube Channel",
      "newsletter": "Newsletter",
      "todayAt": "Today at",
      "details": "DETAILS",
      "watch": "WATCH"
    }
  };

  String getString(String stringName) {
    return _localizedValues[locale.languageCode][stringName] ??
        "MISSING STRING";
  }
}

class MyLocalizationDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) {
    return SynchronousFuture<MyLocalizations>(MyLocalizations(locale));
  }

  @override
  bool shouldReload(MyLocalizationDelegate old) => false;
}
