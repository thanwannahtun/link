import 'package:flutter/material.dart';

enum PlatformType {
  mobile(380),
  tablet(780),
  laptop(1300),
  desktop(1500);

  final int width;
  const PlatformType(this.width);

  operator >(PlatformType other) {
    return width > other.width;
  }

  static double? innerWidth(BuildContext context) {
    return context.size?.width;
  }

  static double? innerHeight(BuildContext context) {
    return context.size?.height;
  }

  static bool isMobile(BuildContext context) =>
      (context.size?.width ?? 0) <= PlatformType.mobile.width;

  static bool isTablet(BuildContext context) =>
      (context.size?.width ?? 0) >= PlatformType.mobile.width &&
      (context.size?.width ?? 0) <= PlatformType.laptop.width;

  static bool isLapTop(BuildContext context) =>
      (context.size?.width ?? 0) >= PlatformType.tablet.width &&
      (context.size?.width ?? 0) <= PlatformType.desktop.width;

  static bool isDeskTop(BuildContext context) =>
      (context.size?.width ?? 0) > PlatformType.laptop.width;

  /// [hello]
// !  world
// * nice
// todo : great
// ? normal
  static PlatformType currentPlatform(BuildContext context) {
    PlatformType platform;
    if (isDeskTop(context)) {
      platform = PlatformType.desktop;
    } else if (isLapTop(context)) {
      platform = PlatformType.laptop;
    } else if (isMobile(context)) {
      platform = PlatformType.mobile;
    } else {
      platform = PlatformType.tablet;
    }
    return platform;
  }
}
