import 'package:flutter/material.dart';
import 'package:fox_mate_app/constants/custom_colors.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Plus Jakarta Sans',
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: CustomColors.primaryColor,
      onPrimary: Colors.white,
      secondary: CustomColors.secondaryColor,
      tertiary: CustomColors.lightGrayColor,
      onTertiary:  CustomColors.textColor ,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,

      surface: CustomColors.backgroundColor,
      onSurface: CustomColors.textColor,
    ),

    scaffoldBackgroundColor: CustomColors.backgroundColor,

    appBarTheme: AppBarTheme(
      backgroundColor: CustomColors.backgroundColor,
      foregroundColor: CustomColors.primaryColor,
      elevation: 0,
      centerTitle: true
    ),

    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: CustomColors.primaryColor,
        fontSize: 40,
        fontWeight: FontWeight.w900,
      ),
      headlineMedium: TextStyle(
        color: CustomColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: CustomColors.textColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: CustomColors.textColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: CustomColors.textColor,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: CustomColors.textColor,
        fontSize: 12,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: CustomColors.primaryColor,
        side: BorderSide(color: CustomColors.primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: CustomColors.primaryColor),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Plus Jakarta Sans',
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: CustomColors.primaryColor,
      onPrimary: Colors.white,
      secondary: CustomColors.secondaryColor,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: CustomColors.darkBackgroundColor,
      onSurface: Colors.white,
    ),

    scaffoldBackgroundColor: CustomColors.darkBackgroundColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: CustomColors.darkBackgroundColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 14),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 12),
      bodySmall: TextStyle(color: Colors.white, fontSize: 10),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: CustomColors.secondaryColor,
        side: BorderSide(color: CustomColors.secondaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white70),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: CustomColors.primaryColor),
      ),
    ),
  );
}
