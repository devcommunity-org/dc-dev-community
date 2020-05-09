import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

extension WidgetExtension on Widget {
  openLink(String url) async {
    if (kIsWeb) {
      html.window.open(url, '_blank');
    } else {
      if (await canLaunch(url)) {
        launch(url);
      }
    }
  }
}