import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'hunter_colors.dart';
import 'hunter_typography.dart';

/// Project Hunter Theme Configuration
class HunterTheme {
  HunterTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: HunterColors.background,
      primaryColor: HunterColors.electricBlue,
      canvasColor: HunterColors.background,
      colorScheme: const ColorScheme.dark(
        primary: HunterColors.electricBlue,
        secondary: HunterColors.cyan,
        surface: HunterColors.surfacePrimary,
        error: HunterColors.danger,
        onPrimary: Color(0xFF080B12),
        onSecondary: Color(0xFF080B12),
        onSurface: HunterColors.textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardTheme(
        color: HunterColors.surfacePrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: HunterColors.borderThin,
            width: 1,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: HunterColors.surfacePrimary,
        selectedItemColor: HunterColors.cyan,
        unselectedItemColor: HunterColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HunterColors.cyan,
          foregroundColor: const Color(0xFF080B12),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: HunterTypography.buttonText,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HunterColors.surfacePrimary,
        hintStyle: HunterTypography.bodyMedium.copyWith(color: HunterColors.textMuted),
        labelStyle: HunterTypography.bodyMedium.copyWith(color: HunterColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: HunterColors.borderThin, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: HunterColors.borderThin, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: HunterColors.cyan, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: HunterColors.danger, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: HunterColors.borderThin,
        thickness: 1,
        space: 24,
      ),
    );
  }
}
