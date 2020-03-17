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
      'pageTitle': 'DC Dev Community',
      "aboutUs": "About Us",
      "volunteerToSpeak": "Volunteer to Speak",
      "homeBodyText": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce risus justo, egestas vitae diam vel, fermentum ornare massa. Quisque quis risus a felis lacinia auctor. Proin efficitur dui eget nisi vehicula venenatis in et sapien. Nam eu porta erat. In ultrices ultricies tincidunt. Maecenas auctor sed nisl ac varius. Integer vulputate tempus augue, eu feugiat arcu elementum ac. In dignissim ut nulla sit amet elementum. Nulla quis nunc nec nisl ornare finibus. Phasellus aliquet diam a libero volutpat luctus porta vitae massa. Nullam condimentum, metus nec efficitur feugiat, est tortor interdum augue, convallis suscipit lorem velit ut justo. Maecenas enim sem, egestas non fringilla a, porta quis quam. Nulla et tempus est.Sed faucibus sem in quam volutpat, et malesuada nisi consequat. \n\nPraesent ultricies sollicitudin lorem, in faucibus risus semper non. Donec bibendum nisl id mauris lobortis euismod. Nulla interdum, tortor a dapibus ornare, elit ante eleifend purus, nec posuere felis ex non nulla. Maecenas interdum, velit vel lobortis laoreet, massa massa congue diam, sed ullamcorper justo augue in erat. Morbi velit urna, consequat quis quam at, porttitor congue ligula. Ut faucibus dapibus eros, at vulputate eros elementum id. Ut vulputate arcu tempus, tempor massa sed, ornare eros. Integer tristique enim eget accumsan consequat. Donec convallis felis vel imperdiet sodales. Etiam malesuada sem eget nulla gravida lacinia. Cras condimentum leo nec turpis ultrices, in fermentum risus vestibulum. Maecenas sit amet dolor aliquam, interdum lorem vitae, efficitur felis. Proin sit amet interdum nisi.",
      "upcomingMeetups": "Upcoming Meetups",
      "volunteerToSpeak": "Volunteer to Speak"
}
  };

  String getString(String stringName) {
    return _localizedValues[locale.languageCode][stringName] ?? "MISSING STRING";
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