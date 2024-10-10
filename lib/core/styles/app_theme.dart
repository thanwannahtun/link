import 'package:flutter/material.dart';
import 'package:link/core/styles/app_colors.dart';
import 'package:link/core/utils/app_insets.dart';

/*
      textTheme: GoogleFonts.robotoTextTheme(), // header , body
      textTheme: GoogleFonts.workSansTextTheme(), // body text theme
 */
class AppTheme {
  static ThemeData get lightTheme {
    const bottomNavigationBarThemeData = BottomNavigationBarThemeData(
      backgroundColor: LightTheme.tertiaryBg,
      selectedItemColor: LightTheme.onPrimary,
      unselectedItemColor: LightTheme.secondaryBg,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
      ),
      elevation: 8.0,
    );

    ///
    const colorScheme = ColorScheme.light(
      primary: LightTheme.primaryBg,
      secondary: LightTheme.secondaryBg,
      tertiary: LightTheme.tertiaryBg,
      onPrimary: Colors.white,
    );

    return ThemeData(
      scaffoldBackgroundColor: const Color.fromARGB(255, 241, 248, 250),
      appBarTheme: const AppBarTheme(
        backgroundColor: LightTheme.tertiaryBg,
        titleTextStyle: TextStyle(
            color: LightTheme.onPrimary,
            fontSize: AppInsets.font25,
            fontWeight: FontWeight.bold),
      ),

      brightness: Brightness.light,
      primaryColor: LightTheme.primaryBg,
      // textTheme: lightTextTheme, //
      dividerColor: LightTheme.primaryAsset,
      // elevatedButtonTheme: elevatedButtonThemeData,
      // textButtonTheme: textButtonThemeData,
      // outlinedButtonTheme: outlinedButtonThemeData,
      colorScheme: colorScheme, // [important]
      bottomNavigationBarTheme: bottomNavigationBarThemeData,
    );
  }

  /// Dark Theme
  ///
  static ThemeData get darkTheme {
    ///
    const bottomNavigationBarThemeData = BottomNavigationBarThemeData(
      backgroundColor: DarkTheme.secondaryBg,
      selectedItemColor: DarkTheme.onPrimary,
      unselectedItemColor: DarkTheme.primaryBg,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
      ),
      elevation: 8.0,
    );

    ///
    const colorScheme = ColorScheme.dark(
      primary: DarkTheme.primaryBg,
      secondary: DarkTheme.secondaryBg,
      tertiary: DarkTheme.tertiaryBg,
      onPrimary: Colors.white,
    );

    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFF0E0D0D),
      appBarTheme: const AppBarTheme(
        backgroundColor: DarkTheme.tertiaryBg,
        titleTextStyle: TextStyle(
            color: LightTheme.onPrimary,
            fontSize: AppInsets.font25,
            fontWeight: FontWeight.bold),
      ),

      brightness: Brightness.dark,
      primaryColor: DarkTheme.primaryBg,
      // textTheme: lightTextTheme, //
      dividerColor: DarkTheme.primaryAsset,
      // elevatedButtonTheme: elevatedButtonThemeData,
      // textButtonTheme: textButtonThemeData,
      // outlinedButtonTheme: outlinedButtonThemeData,
      colorScheme: colorScheme, // [important]
      bottomNavigationBarTheme: bottomNavigationBarThemeData,
    );
  }
}
