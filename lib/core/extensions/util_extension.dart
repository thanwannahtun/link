import 'package:flutter/material.dart';

// extension UtilExtension on BuildContext {
//   Size get size {
//     return MediaQuery.of(this).size;
//   }
// }

extension UtilExtension on BuildContext {
  /// Screen size (width and height)
  Size get screenSize {
    return MediaQuery.maybeOf(this)?.size ?? const Size(0, 0);
  }

  /// Screen width
  double get screenWidth => screenSize.width;

  /// Screen height
  double get screenHeight => screenSize.height;

  /// Whether MediaQuery is available
  bool get isMediaQueryAvailable => MediaQuery.maybeOf(this) != null;

  /// Whether the device is considered a desktop (based on screen width)
  bool get isDesktop => screenWidth >= 1240;

  /// Whether the device is considered a tablet (based on screen width)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1240;

  /// Whether the device is considered a mobile phone (based on screen width)
  bool get isMobile => screenWidth < 600;

  /// Device type classification (Phone, Tablet, Desktop)
  String get deviceType {
    if (isDesktop) return 'Desktop';
    if (isTablet) return 'Tablet';
    return 'Phone';
  }

  /// Whether the device is in landscape orientation
  bool get isLandscape => screenWidth > screenHeight;

  /// Whether the device is in portrait orientation
  bool get isPortrait => screenHeight > screenWidth;

  /// Pixel density (useful for high-density screens)
  double get devicePixelRatio =>
      MediaQuery.maybeOf(this)?.devicePixelRatio ?? 1.0;
}
