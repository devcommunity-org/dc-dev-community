import 'package:flutter/material.dart';

import '../sizing_information.dart';
import '../utils.dart';

class BaseWidget extends StatelessWidget {
  final Widget Function(
      BuildContext context, SizingInformation sizingInformation) builder;

  const BaseWidget({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(builder: (context, boxSizing) {
      var sizingInformation = SizingInformation(
        orientation: mediaQuery.orientation,
        deviceType: Utils().getDeviceType(mediaQuery),
        screenSize: mediaQuery.size,
        localWidgetSize: Size(boxSizing.maxWidth, boxSizing.maxHeight),
      );
      return builder(context, sizingInformation);
    });
  }
}
