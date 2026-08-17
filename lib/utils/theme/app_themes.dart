import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();
  
  static const Color background = Color(0xFF0A1A0A);
  static const Color surface = Color(0xFF122412);
  static const Color card = Color(0xFF1A2E1A);
  static const Color cardSelected = Color(0xFF254025);
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryLight = Color(0xFF81C784);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color border = Color(0xFF2E7D32);
  static const Color borderSelected = Color(0xFF66BB6A);
  static const Color divider = Color(0xFF1B3A1B);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.figtree().fontFamily,
    scaffoldBackgroundColor: background,

    primaryColor: primary,

    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: primaryLight,
      surface: surface,
      outline: divider,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        elevation: 0,
      ),
    ),

    textTheme: GoogleFonts.figtreeTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),

        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),

        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),

        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          height: 1.5,
        ),

        bodyMedium: TextStyle(
          color: textPrimary,
          fontSize: 14,
          height: 1.5,
        ),

        labelLarge: TextStyle(
          color: textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
    ),

    dividerColor: divider,

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
    ),
  );
}
