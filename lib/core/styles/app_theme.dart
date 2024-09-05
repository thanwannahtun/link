import 'package:flutter/material.dart';
import 'package:link/core/styles/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.green,
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: AppBarTheme(
        color: AppColors.green,
        iconTheme: const IconThemeData(color: AppColors.black),
        toolbarTextStyle: const TextTheme(
          titleLarge: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ).bodyMedium,
        titleTextStyle: const TextTheme(
          titleLarge: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ).titleLarge,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.green,
        textTheme: ButtonTextTheme.normal,
      ),
      textTheme: const TextTheme(
        // Display Styles (for large, prominent text like banners)
        displayLarge: TextStyle(
          color: AppColors
              .black, // Darker color for readability on light background
          fontSize: 57,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),
        displayMedium: TextStyle(
          color: AppColors.black,
          fontSize: 45,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),
        displaySmall: TextStyle(
          color: AppColors.black,
          fontSize: 36,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),

        // Headline Styles (for section headers)
        headlineLarge: TextStyle(
          color: AppColors.black,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),
        headlineMedium: TextStyle(
          color: AppColors.black,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),
        headlineSmall: TextStyle(
          color: AppColors.black,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),

        // Title Styles (for smaller headings)
        titleLarge: TextStyle(
          color: AppColors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),
        titleMedium: TextStyle(
          color: AppColors.blue, // Slightly colored for emphasis
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),
        titleSmall: TextStyle(
          color: AppColors.blue,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),

        // Body Text (for regular content)
        bodyLarge: TextStyle(
          color: AppColors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
          fontFamily: 'Roboto',
        ),
        bodyMedium: TextStyle(
          color: AppColors.green50, // Muted green for subtle text
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.4,
          fontFamily: 'Roboto',
        ),
        bodySmall: TextStyle(
          color: AppColors.green50,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          height: 1.3,
          fontFamily: 'Roboto',
        ),

        // Label Text (for buttons, badges, etc.)
        labelLarge: TextStyle(
          color: AppColors.white, // White for contrast on buttons
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
        labelMedium: TextStyle(
          color: AppColors.blue, // Blue for clickable labels
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
        labelSmall: TextStyle(
          color: AppColors.blue,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.blue,
      ),
      cardColor: AppColors.white,
      dividerColor: AppColors.grey,
      colorScheme: const ColorScheme.light(
        primary: AppColors.green,
        onPrimary: AppColors.white,
        surface: AppColors.lightGrey,
        onSurface: AppColors.black,
        secondary: AppColors.blue,
        onSecondary: AppColors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.green,
        unselectedItemColor: AppColors.grey,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
        ),
        elevation: 8.0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.darkBlue,
      scaffoldBackgroundColor: AppColors.black,
      appBarTheme: AppBarTheme(
        color: AppColors.darkBlue,
        iconTheme: const IconThemeData(color: AppColors.white),
        toolbarTextStyle: const TextTheme(
          titleLarge: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ).bodyMedium,
        titleTextStyle: const TextTheme(
          titleLarge: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ).titleLarge,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: const TextTheme(
        // Display Styles (for large, prominent text like banners)
        displayLarge: TextStyle(
          color: AppColors.white,
          fontSize: 57,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),
        displayMedium: TextStyle(
          color: AppColors.white,
          fontSize: 45,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),
        displaySmall: TextStyle(
          color: AppColors.white,
          fontSize: 36,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),

        // Headline Styles (for section headers)
        headlineLarge: TextStyle(
          color: AppColors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),
        headlineMedium: TextStyle(
          color: AppColors.white,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),
        headlineSmall: TextStyle(
          color: AppColors.white,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),

        // Title Styles (for smaller headings)
        titleLarge: TextStyle(
          color: AppColors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),
        titleMedium: TextStyle(
          color: AppColors.lightGrey,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),
        titleSmall: TextStyle(
          color: AppColors.lightGrey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          fontFamily: 'Roboto',
        ),

        // Body Text (for regular content)
        bodyLarge: TextStyle(
          color: AppColors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
          fontFamily: 'Roboto',
        ),
        bodyMedium: TextStyle(
          color: AppColors.lightGrey,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.4,
          fontFamily: 'Roboto',
        ),
        bodySmall: TextStyle(
          color: AppColors.lightGrey,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          height: 1.3,
          fontFamily: 'Roboto',
        ),

        // Label Text (for buttons, badges, etc.)
        labelLarge: TextStyle(
          color: AppColors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
        labelMedium: TextStyle(
          color: AppColors.lightGrey,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
        labelSmall: TextStyle(
          color: AppColors.lightGrey,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto',
        ),
      ),

      ///
      iconTheme: const IconThemeData(
        color: AppColors.green50,
      ),
      cardColor: AppColors.darkGrey,
      dividerColor: AppColors.grey,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkBlue,
        onPrimary: AppColors.white,
        surface: AppColors.darkGrey,
        onSurface: AppColors.white,
        secondary: AppColors.green,
        onSecondary: AppColors.black,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.black,
        selectedItemColor: AppColors.green50,
        unselectedItemColor: AppColors.grey,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
        ),
        elevation: 8.0,
      ),
    );
  }
}
