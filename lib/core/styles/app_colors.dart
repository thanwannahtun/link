import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF05F819);
}

class DarkTheme {
  // static const Color primaryBg = Color(0xff5E5E5E);
  static const Color primaryBg = Color(0xff46474d);
  static const Color tertiaryBg = Color(0xff1E1E1E);
  static const Color secondaryBg = Color(0xff000000);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color primaryText = Color(0xffFFFFFF); // text

  static const Color primaryAsset = Color(0xffFFFFFF); // divider , border
  static const Color greyFilled = Color(0xffD8DFE5); // divider , border

  static const Color buttonTextColor = Color(0xff809fff);
  static const Color buttonIconColor = Color(0xff1565C0);
  static const Color buttonBgColor = Color(0x692c3543);

}

class LightTheme {
  static const Color primaryBg =
      // Color(0xff64B5F6); // Light blue background for general UI areas
      Color(0xffdee7f1); // Light blue background for general UI areas
  static const Color secondaryBg =
      Color(0xff1565C0); // Medium blue for material widgets, icons
  static const Color tertiaryBg =
      Color(0xff64B5F6); // Soft blue for cards, lists, etc.

  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color primaryText = Color(0xff01070A);
  static const Color secondaryText = Color(0xff01070A);
  static const Color tertiaryText = Color(0xff01070A);

  static const Color primaryAsset = Color(0xffD8DFE5); // divider , border
  static const Color greyFilled = Color(0xffD8DFE5); // divider , border


  static const Color buttonTextColor = Color(0xffD8DFE5);
  static const Color buttonBgColor = Color(0xff0000ff);
  static const Color buttonIconColor = Color(0xffF1F5F9);
}
