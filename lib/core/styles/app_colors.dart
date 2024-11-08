import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF05F819);
}

class DarkTheme {
  static const Color primaryBg = Color(0xff5E5E5E);
  static const Color tertiaryBg = Color(0xff1E1E1E);
  static const Color secondaryBg = Color(0xff000000);
  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color primaryText = Color(0xffFFFFFF); // text
  // static const Color secondaryText = Color(0xff01070A); // text
  // static const Color tertiaryText = Color(0xff01070A); // text

  static const Color primaryAsset = Color(0xffFFFFFF); // divider , border
}

class LightTheme {
  // static const Color primaryBg = Color(0xffC7C7C7); // bg
  // static const Color secondaryBg = Color(0xff46656F); // material widget , icon
  // static const Color tertiaryBg = Color(0xff8FABB7); // card , list , etc

  static const Color primaryBg =
      Color(0xffE3F2FD); // Light blue background for general UI areas
  static const Color secondaryBg =
      Color(0xff1565C0); // Medium blue for material widgets, icons
  static const Color tertiaryBg =
      Color(0xff64B5F6); // Soft blue for cards, lists, etc.

  static const Color onPrimary = Color(0xFFFFFFFF);

  static const Color primaryText = Color(0xff01070A);
  static const Color secondaryText = Color(0xff01070A);
  static const Color tertiaryText = Color(0xff01070A);

  static const Color primaryAsset = Color(0xffD8DFE5); // divider , border
}

/*
for light theme 

primaryBg , C7C7C7 ( white dark )
secondaryBg , ECECEC ( white pale )
tertiaryBg , FFFFFF ( white bright )
primaryAsset , 1E1E1E ( black -> icon , material utilities )

primaryText , 1E1E1E ( black )
secondaryText , FFFFFF  ( white )
tertiaryText , for 80 % pale primary
 */
/*
for dark theme 

primaryBg , 5E5E5E ( dark nav )
secondaryBg , 1E1E1E ( dark body )
tertiaryBg , 000000 ( dark util )
primaryAsset , FFFFFF ( white -> icon , material utilities )

primaryText , FFFFFF ( white )
secondaryText , FFFFFF  ( white )
tertiaryText , for 80 % pale primary
 */
