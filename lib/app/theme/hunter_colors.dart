import 'package:flutter/material.dart';

/// Project Hunter Design Tokens - Colors
class HunterColors {
  HunterColors._();

  // Primary Canvas & Surfaces
  static const Color background = Color(0xFF080B12);
  static const Color surfacePrimary = Color(0xFF101725);
  static const Color surfaceSecondary = Color(0xFF172235);
  static const Color surfaceElevated = Color(0xFF1E2C44);
  static const Color surfaceGlass = Color(0x33101725);

  // Holographic & Accent Lights
  static const Color electricBlue = Color(0xFF39A9FF);
  static const Color cyan = Color(0xFF00E5FF);
  static const Color cyanGlow = Color(0x6600E5FF);
  static const Color electricBlueGlow = Color(0x6639A9FF);

  // Status & Feedback
  static const Color success = Color(0xFF36D399);
  static const Color warning = Color(0xFFFFB547);
  static const Color danger = Color(0xFFF87272);
  static const Color info = Color(0xFF38BDF8);

  // Typography
  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textHighlight = Color(0xFF00E5FF);

  // Borders & Dividers
  static const Color borderThin = Color(0xFF1E2E4A);
  static const Color borderGlow = Color(0xFF2E4B77);
  static const Color borderActive = Color(0xFF00E5FF);

  // Hunter Ranks
  static const Color rankE = Color(0xFF94A3B8); // Rookie (Iron/Gray)
  static const Color rankD = Color(0xFF4ADE80); // Apprentice (Green)
  static const Color rankC = Color(0xFF38BDF8); // Skilled (Blue)
  static const Color rankB = Color(0xFFA855F7); // Elite (Purple)
  static const Color rankA = Color(0xFFF59E0B); // Master (Gold)
  static const Color rankS = Color(0xFFEF4444); // Legendary (Crimson Red)

  // Gradients
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF131D30),
      Color(0xFF0D1424),
    ],
  );

  static const LinearGradient holographicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x3300E5FF),
      Color(0x1139A9FF),
      Color(0x05080B12),
    ],
  );

  static const LinearGradient electricButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF39A9FF),
      Color(0xFF00E5FF),
    ],
  );

  static const LinearGradient xpBarGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF2563EB),
      Color(0xFF39A9FF),
      Color(0xFF00E5FF),
    ],
  );
}
