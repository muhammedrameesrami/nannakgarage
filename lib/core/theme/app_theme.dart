import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_palette.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ColorPalette.backgroundColor,
      primaryColor: ColorPalette.primaryColor,
      colorScheme: const ColorScheme.light(
        primary: ColorPalette.primaryColor,
        secondary: ColorPalette.secondaryColor,
        error: ColorPalette.statusError,
        surface: ColorPalette.cardColor,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: ColorPalette.textPrimary,
        displayColor: ColorPalette.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorPalette.cardColor,
        elevation: 0,
        iconTheme: IconThemeData(color: ColorPalette.textPrimary),
        titleTextStyle: TextStyle(
          color: ColorPalette.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: ColorPalette.cardColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: ColorPalette.borderColor, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorPalette.primaryColor,
          side: const BorderSide(color: ColorPalette.primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorPalette.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorPalette.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorPalette.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: ColorPalette.statusError),
        ),
        hintStyle: const TextStyle(color: ColorPalette.textMuted),
        labelStyle: const TextStyle(color: ColorPalette.textSecondary),
      ),
      dividerTheme: const DividerThemeData(
        color: ColorPalette.borderColor,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
