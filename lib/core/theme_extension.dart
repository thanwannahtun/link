import 'package:flutter/material.dart';

extension TextThemeExtensions on BuildContext {
  // Accessing Text Colors
  Color get textColor =>
      Theme.of(this).textTheme.bodyLarge?.color ?? Colors.black;
  Color get titleColor =>
      Theme.of(this).textTheme.titleLarge?.color ?? Colors.black;

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
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get appBarColor =>
      Theme.of(this).appBarTheme.backgroundColor ?? primaryColor;

  // Accessing Icon Themes
  IconThemeData get appBarIconTheme =>
      Theme.of(this).appBarTheme.iconTheme ?? const IconThemeData();
  IconThemeData get iconTheme => Theme.of(this).iconTheme;
}
