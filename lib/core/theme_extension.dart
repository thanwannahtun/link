import 'package:flutter/material.dart';
import 'package:link/core/styles/app_theme.dart';

extension AppThemeExt on BuildContext {
  ThemeData get lightTheme => AppTheme.lightTheme;
  ThemeData get darkTheme => AppTheme.darkTheme;
}

extension TextThemeExtensions on BuildContext {
  /// Colors
  Color get primaryColor => Theme.of(this).colorScheme.primary;
  Color get onPrimaryColor => Theme.of(this).colorScheme.onPrimary;
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;
  Color get tertiaryColor => Theme.of(this).colorScheme.tertiary;

  // Accessing Text Colors

  Color get titleColor =>
      Theme.of(this).textTheme.titleLarge?.color ?? const Color(0xFF000000);

  // Accessing Font Sizes
  double get bodyLargeFontSize =>
      Theme.of(this).textTheme.bodyLarge?.fontSize ?? 16.0;
  double get titleLargeFontSize =>
      Theme.of(this).textTheme.titleLarge?.fontSize ?? 22.0;

  // Accessing Font Weights
  FontWeight get bodyLargeFontWeight =>
      Theme.of(this).textTheme.bodyLarge?.fontWeight ?? FontWeight.normal;
  FontWeight get titleLargeFontWeight =>
      Theme.of(this).textTheme.titleLarge?.fontWeight ?? FontWeight.bold;

  // Accessing Specific Text Styles
  TextStyle get bodyLargeStyle =>
      Theme.of(this).textTheme.bodyLarge ?? const TextStyle();
  TextStyle get titleLargeStyle =>
      Theme.of(this).textTheme.titleLarge ?? const TextStyle();

  // Accessing Colors
  Color get primarySwatch => Theme.of(this).colorScheme.onPrimary;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get appBarColor =>
      Theme.of(this).appBarTheme.backgroundColor ?? primaryColor;

  // Accessing Icon Themes
  IconThemeData get appBarIconTheme =>
      Theme.of(this).appBarTheme.iconTheme ?? const IconThemeData();
  IconThemeData get iconTheme => Theme.of(this).iconTheme;
}
