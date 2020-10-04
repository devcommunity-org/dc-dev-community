import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

import 'enums/enums.dart';
import 'l10n/generated/app_localizations.dart';
import 'widgets/menu_button.dart';

class Utils {
  static final Utils _singleton = new Utils._internal();

  factory Utils() {
    return _singleton;
  }

  Utils._internal();

  DeviceScreenType getDeviceType(MediaQueryData mediaQuery) {
    double deviceWidth = mediaQuery.size.width;

    //var orientation = mediaQuery.orientation;  //TODO: Look into orientation changes and how it impacts deviceWidth calculation
    // if (orientation == Orientation.landscape) {
    //   deviceWidth = mediaQuery.size.height;
    // } else {
    //   deviceWidth = mediaQuery.size.width;
    // }

    if (deviceWidth > 1200) {
      return DeviceScreenType.desktop;
    }
    if (deviceWidth > 600) {
      return DeviceScreenType.tablet;
    }
    return DeviceScreenType.mobile;
  }

  openLink(String url) async {
    if (kIsWeb) {
      html.window.open(url, '_blank');
    } else {
      if (await canLaunch(url)) {
        launch(url);
      }
    }
  }

  String urlForButtonAction(ButtonType buttonType) {
    switch (buttonType) {
      case ButtonType.newsletter:
        return "https://docs.google.com/forms/d/e/1FAIpQLSdZFjPBUEjWzJYDp0Th2GI5hoxsEvKHbJFd0h-kM4x4ukDjlQ/viewform?usp=sf_link";
        break;
      case ButtonType.contribute:
        return "https://github.com/devcommunity-org/dc-dev-community";
        break;
      case ButtonType.volunteer:
        return "https://docs.google.com/forms/d/e/1FAIpQLSeFiweTDZknMj2F3rx_alFS5VV5axn766sItUfyOy2KvVephw/viewform";
        break;
      case ButtonType.videos:
        return "https://www.youtube.com/c/DevCommunity/videos";
        break;
      case ButtonType.social:
        return "https://twitter.com/devcommunityorg";
        break;
    }

    return "";
  }

  MenuButton menuButtonForType(
      ButtonType type, bool isForDrawer, BuildContext context) {
    switch (type) {
      case ButtonType.newsletter:
        return MenuButton(
          title: AppLocalizations.of(context).newsletter,
          action: () => Utils()
              .openLink(Utils().urlForButtonAction(ButtonType.newsletter)),
          iconWidget: Icon(Icons.email, color: Colors.white),
          isForDrawer: isForDrawer,
        );
        break;
      case ButtonType.contribute:
        return MenuButton(
            title: AppLocalizations.of(context).contribute,
            action: () => Utils()
                .openLink(Utils().urlForButtonAction(ButtonType.contribute)),
            iconWidget: Image.asset(
              'assets/images/github-icon.png',
              height: 26,
              width: 26,
            ),
            isForDrawer: isForDrawer);
        break;
      case ButtonType.volunteer:
        return MenuButton(
            title: AppLocalizations.of(context).volunteerToSpeak,
            action: () => Utils()
                .openLink(Utils().urlForButtonAction(ButtonType.volunteer)),
            iconWidget: Icon(Icons.record_voice_over, color: Colors.white),
            isForDrawer: isForDrawer);
        break;
      case ButtonType.videos:
        return MenuButton(
            title: AppLocalizations.of(context).videos,
            action: () =>
                Utils().openLink(Utils().urlForButtonAction(ButtonType.videos)),
            iconWidget: Icon(Icons.video_library, color: Colors.white),
            isForDrawer: isForDrawer);
        break;
      case ButtonType.social:
        return MenuButton(
            title: AppLocalizations.of(context).twitterHandle,
            action: () =>
                Utils().openLink(Utils().urlForButtonAction(ButtonType.social)),
            iconWidget: Image.asset(
              'assets/images/twitter-icon.png',
              height: 26,
              width: 26,
            ),
            isForDrawer: isForDrawer);
      case ButtonType.about:
        return MenuButton(
            title: AppLocalizations.of(context).about,
            action: () => showAboutDialog(
                  context: context,
                  applicationIcon: Image(
                    image: AssetImage('assets/images/logo-no-text.png'),
                    width: 60,
                  ),
                  applicationName: 'DevCommunity',
                  applicationVersion: '1.0',
                  applicationLegalese: '© 2020 DevCommunity',
                ),
            iconWidget: Icon(Icons.help, color: Colors.white),
            isForDrawer: isForDrawer);
        break;
    }

    return null;
  }

  void _showDialog(
      BuildContext context, String title, String content, String buttonText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
