import 'package:flutter/material.dart';
import '../../app/theme/hunter_colors.dart';
import '../../app/theme/hunter_typography.dart';
import 'hunter_progress_bar.dart';

class AttributeStatCard extends StatelessWidget {
  final String label;
  final String code; // STR, AGI, VIT, END, DIS
  final int value;
  final double progress;
  final IconData icon;
  final Color accentColor;

  const AttributeStatCard({
    super.key,
    required this.label,
    required this.code,
    required this.value,
    required this.progress,
    required this.icon,
    this.accentColor = HunterColors.cyan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: HunterColors.surfacePrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 14, color: accentColor),
                  const SizedBox(width: 6),
                  Text(
                    code,
                    style: HunterTypography.systemSub.copyWith(
                      color: accentColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Text(
                '$value',
                style: HunterTypography.displaySmall.copyWith(
                  fontSize: 16,
                  color: HunterColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: HunterTypography.bodySmall.copyWith(
              fontSize: 10,
              color: HunterColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          HunterProgressBar(
            progress: progress,
            height: 4,
            gradient: LinearGradient(
              colors: [accentColor.withOpacity(0.6), accentColor],
            ),
            showGlow: false,
          ),
        ],
      ),
    );
  }
}
