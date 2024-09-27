import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:link/core/styles/app_colors.dart';
import 'package:link/core/utils/app_insets.dart';

/*
      textTheme: GoogleFonts.robotoTextTheme(), // header , body
      textTheme: GoogleFonts.workSansTextTheme(), // body text theme
 */
class AppTheme {
  static ThemeData get lightTheme {
    var textButtonThemeData = TextButtonThemeData(
      style: ButtonStyle(
        surfaceTintColor: const WidgetStatePropertyAll(LightTheme.primaryAsset),
        foregroundColor: WidgetStateProperty.all(LightTheme.secondaryText),
        backgroundColor: WidgetStateProperty.all(LightTheme.tertiaryBg),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), side: BorderSide.none),
        ),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0)),
      ),
    );
    var outlinedButtonThemeData = OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(LightTheme.secondaryText),
        backgroundColor: WidgetStateProperty.all(LightTheme.secondaryBg),
        side: WidgetStateProperty.all(
            const BorderSide(color: LightTheme.primaryAsset)),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
    var elevatedButtonThemeData = ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(LightTheme.secondaryText),
        backgroundColor: WidgetStateProperty.all(LightTheme.secondaryBg),
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), side: BorderSide.none),
        ),
      ),
    );
    TextTheme lightTextTheme = GoogleFonts.robotoTextTheme(const TextTheme(
      titleLarge: TextStyle(
        color: LightTheme.primaryText,
      ),
    ));
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
