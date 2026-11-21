import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hunter_colors.dart';

/// Project Hunter Typography Tokens
class HunterTypography {
  HunterTypography._();

  // Display Headings (Space Grotesk)
  static TextStyle get displayLarge => GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: HunterColors.textPrimary,
      );

  static TextStyle get displayMedium => GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: HunterColors.textPrimary,
      );

  static TextStyle get displaySmall => GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: HunterColors.textPrimary,
      );

  // System RPG Labels & Status Callouts
  static TextStyle get systemTitle => GoogleFonts.spaceGrotesk(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: HunterColors.cyan,
      );

  static TextStyle get systemSub => GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: HunterColors.textSecondary,
      );

  // Body Styles (Inter)
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: HunterColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: HunterColors.textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: HunterColors.textMuted,
      );

  // Stat Numeric Values
  static TextStyle get statNumber => GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: HunterColors.textPrimary,
      );

  static TextStyle get statLabel => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
        color: HunterColors.textSecondary,
      );

  // Button Typography
  static TextStyle get buttonText => GoogleFonts.spaceGrotesk(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: const Color(0xFF080B12),
      );
}
