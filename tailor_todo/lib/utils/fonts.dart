import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppFonts {
  static TextStyle spectral({
    Color? color,
    double? size,
    FontWeight weight = FontWeight.w300, // Spectral Light 300
  }) => GoogleFonts.spectral(color: color, fontSize: size, fontWeight: weight);

  static TextStyle cardo({
    Color? color,
    double? size,
    FontWeight weight = FontWeight.w400, // Cardo Regular 400
  }) => GoogleFonts.cardo(color: color, fontSize: size, fontWeight: weight);
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.accent,
      secondary: AppColors.accent,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.primary,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: AppFonts.cardo(color: AppColors.onDark.withOpacity(0.7)),
      labelStyle: AppFonts.cardo(color: AppColors.onDark),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.inputBorder, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
    ),
    textTheme: TextTheme(
      headlineMedium: AppFonts.spectral(color: AppColors.brandText, size: 28),
      bodyMedium: AppFonts.cardo(color: AppColors.onDark, size: 16),
      labelLarge: AppFonts.cardo(color: AppColors.onDark, size: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.surface,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: AppFonts.cardo(size: 16),
      ),
    ),
  );
}
