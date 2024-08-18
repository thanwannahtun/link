import 'package:flutter/material.dart';

enum Platform {
  mobile(380),
  tablet(780),
  laptop(1300),
  desktop(1500);

  final int width;
  const Platform(this.width);

  operator >(Platform other) {
    return width > other.width;
  }

  static double? innerWidth(BuildContext context) {
    return context.size?.width;
  }

  static double? innerHeight(BuildContext context) {
    return context.size?.height;
  }

  static bool isMobile(BuildContext context) =>
      (context.size?.width ?? 0) <= Platform.mobile.width;

  static bool isTablet(BuildContext context) =>
      (context.size?.width ?? 0) >= Platform.mobile.width &&
      (context.size?.width ?? 0) <= Platform.laptop.width;

  static bool isLapTop(BuildContext context) =>
      (context.size?.width ?? 0) >= Platform.tablet.width &&
      (context.size?.width ?? 0) <= Platform.desktop.width;

  static bool isDeskTop(BuildContext context) =>
      (context.size?.width ?? 0) > Platform.laptop.width;

  /// [hello]
// !  world
// * nice
// todo : great
// ? normal
  static Platform currentPlatform(BuildContext context) {
    Platform platform;
    if (isDeskTop(context)) {
      platform = Platform.desktop;
    } else if (isLapTop(context)) {
      platform = Platform.laptop;
    } else if (isMobile(context)) {
      platform = Platform.mobile;
    } else {
      platform = Platform.tablet;
    }
    return platform;
  }
}
