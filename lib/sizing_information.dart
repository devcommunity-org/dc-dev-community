import 'package:flutter/widgets.dart';

import 'enums/enums.dart';

class SizingInformation {
  final Orientation orientation;
  final DeviceScreenType deviceType;
  final Size screenSize;
  final Size localWidgetSize;

  SizingInformation({
    this.orientation,
    this.deviceType,
    this.screenSize,
    this.localWidgetSize,
  });

  bool isDesktop() {
    return deviceType == DeviceScreenType.desktop;
  }

  bool isMobile() {
    return deviceType == DeviceScreenType.mobile;
  }

  bool isSmallMobile() {
    return deviceType == DeviceScreenType.mobile && screenSize.width < 400;
  }

  bool isTablet() {
    return deviceType == DeviceScreenType.tablet;
  }

  @override
  String toString() {
    return 'Orientation:$orientation DeviceType:$deviceType ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}
