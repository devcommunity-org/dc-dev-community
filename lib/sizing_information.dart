import 'package:flutter/widgets.dart';

import 'enums/device_screen_type.dart';

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
    return deviceType == DeviceScreenType.Desktop;
  }

  bool isMobile() {
    return deviceType == DeviceScreenType.Mobile;
  }

  bool isTablet() {
    return deviceType == DeviceScreenType.Tablet;
  }

  @override
  String toString() {
    return 'Orientation:$orientation DeviceType:$deviceType ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
  }
}
