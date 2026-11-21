import 'package:flutter/material.dart';
import '../../app/theme/hunter_colors.dart';

enum HunterRank {
  e(code: 'E', title: 'Rookie', minLevel: 1, color: HunterColors.rankE),
  d(code: 'D', title: 'Apprentice', minLevel: 10, color: HunterColors.rankD),
  c(code: 'C', title: 'Skilled', minLevel: 25, color: HunterColors.rankC),
  b(code: 'B', title: 'Elite', minLevel: 50, color: HunterColors.rankB),
  a(code: 'A', title: 'Master', minLevel: 80, color: HunterColors.rankA),
  s(code: 'S', title: 'Legendary', minLevel: 100, color: HunterColors.rankS);

  final String code;
  final String title;
  final int minLevel;
  final Color color;

  const HunterRank({
    required this.code,
    required this.title,
    required this.minLevel,
    required this.color,
  });

  static HunterRank fromLevel(int level) {
    if (level >= 100) return HunterRank.s;
    if (level >= 80) return HunterRank.a;
    if (level >= 50) return HunterRank.b;
    if (level >= 25) return HunterRank.c;
    if (level >= 10) return HunterRank.d;
    return HunterRank.e;
  }

  static HunterRank fromCode(String code) {
    return HunterRank.values.firstWhere(
      (r) => r.code.toUpperCase() == code.toUpperCase(),
      orElse: () => HunterRank.e,
    );
  }

  HunterRank? get nextRank {
    final index = HunterRank.values.indexOf(this);
    if (index < HunterRank.values.length - 1) {
      return HunterRank.values[index + 1];
    }
    return null;
  }
}
