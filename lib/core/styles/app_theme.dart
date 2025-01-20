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
      onSecondary: Color(0xf5f5f5ff),
    );

    TextTheme lightTextTheme = const TextTheme(
      titleMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: LightTheme.secondaryBg),
      titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: LightTheme.primaryText),
      headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: LightTheme.primaryText),
      headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: LightTheme.primaryText),
      headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: LightTheme.primaryText),
      bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: LightTheme.primaryText),
      bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: LightTheme.primaryText),
      labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: LightTheme.primaryText),
      labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: LightTheme.primaryText),
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
      textTheme: lightTextTheme,
      //
      dividerColor: LightTheme.primaryAsset,
      elevatedButtonTheme: elevatedButtonThemeData(),
      textButtonTheme: textButtonThemeData(),
      // outlinedButtonTheme: outlinedButtonThemeData,
      colorScheme: colorScheme,
      // [important]
      iconTheme: const IconThemeData(
        color: Colors.black87, // Slightly darker black for visibility
        size: 24.0, // Default size
        opacity: 1.0, // Fully opaque
      ),
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
      // onSecondary: Color(0xff424242),
      onSecondary: Colors.white10,
    );

    TextTheme darkTextTheme = const TextTheme(
      titleMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: LightTheme.tertiaryBg),
      titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: DarkTheme.primaryText),
      headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: DarkTheme.primaryText),
      headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: DarkTheme.primaryText),
      headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: DarkTheme.primaryText),
      bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: DarkTheme.primaryText),
      bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: DarkTheme.primaryText),
      labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: DarkTheme.primaryText),
      labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: DarkTheme.primaryText),
    );
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFF0E0D0D),
      appBarTheme: const AppBarTheme(
        backgroundColor: DarkTheme.tertiaryBg,
        titleTextStyle: TextStyle(
            color: LightTheme.onPrimary,
            fontSize: AppInsets.font20,
            fontWeight: FontWeight.bold),
      ),

      brightness: Brightness.dark,
      primaryColor: DarkTheme.primaryBg,
      textTheme: darkTextTheme,
      //
      dividerColor: DarkTheme.primaryAsset,
      elevatedButtonTheme: elevatedButtonThemeData(),
      textButtonTheme: textButtonThemeData(),
      // outlinedButtonTheme: outlinedButtonThemeData,
      iconTheme: const IconThemeData(
        color: Colors.white70, // White for visibility in dark backgrounds
        size: 24.0, // Default size
        opacity: 1.0, // Fully opaque
      ),

      colorScheme: colorScheme,
      // [important]
      bottomNavigationBarTheme: bottomNavigationBarThemeData,
    );
  }

  static ElevatedButtonThemeData elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
          color: DarkTheme.primaryText, fontWeight: FontWeight.bold),
      backgroundColor: LightTheme.secondaryBg,
      foregroundColor: LightTheme.primaryBg,
      // disabledBackgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppInsets.inset5)),
      overlayColor: LightTheme.secondaryBg.withBlue(255),
    ));
  }

  static TextButtonThemeData textButtonThemeData() {
    return TextButtonThemeData(
        style: ElevatedButton.styleFrom(
      textStyle:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      foregroundColor: LightTheme.secondaryBg,
      disabledBackgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppInsets.inset5)),
    ));
  }
}
