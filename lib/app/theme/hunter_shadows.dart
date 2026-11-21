import 'package:flutter/material.dart';
import 'hunter_colors.dart';

/// Project Hunter Glow & Elevation Tokens
class HunterShadows {
  HunterShadows._();

  static List<BoxShadow> cyanGlow({double radius = 12.0, double spread = 0.0}) => [
        BoxShadow(
          color: HunterColors.cyanGlow,
          blurRadius: radius,
          spreadRadius: spread,
        ),
      ];

  static List<BoxShadow> electricGlow({double radius = 16.0, double spread = 1.0}) => [
        BoxShadow(
          color: HunterColors.electricBlueGlow,
          blurRadius: radius,
          spreadRadius: spread,
        ),
      ];

  static List<BoxShadow> holographicElevation => [
        const BoxShadow(
          color: Color(0x80000000),
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
        const BoxShadow(
          color: Color(0x1A00E5FF),
          blurRadius: 10,
          spreadRadius: -2,
        ),
      ];

  static List<BoxShadow> subtleCard => [
        const BoxShadow(
          color: Color(0x60000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ];
}
