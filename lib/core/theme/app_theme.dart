import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_palette.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: ColorPalette.primaryColor,
      scaffoldBackgroundColor: ColorPalette.backgroundColor,
      cardColor: ColorPalette.cardColor,
      colorScheme: const ColorScheme.light(
        primary: ColorPalette.primaryColor,
        secondary: ColorPalette.secondaryColor,
        error: ColorPalette.errorColor,
        background: ColorPalette.backgroundColor,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: const TextStyle(
          color: ColorPalette.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: const TextStyle(color: ColorPalette.textPrimary),
        bodyMedium: const TextStyle(color: ColorPalette.textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorPalette.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorPalette.primaryColor),
        ),
        labelStyle: const TextStyle(color: ColorPalette.textSecondary),
      ),
    );
  }
}
