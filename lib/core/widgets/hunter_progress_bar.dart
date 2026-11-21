import 'package:flutter/material.dart';
import '../../app/theme/hunter_colors.dart';

/// Animated futuristic RPG progression bar
class HunterProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Gradient? gradient;
  final Color backgroundColor;
  final bool showGlow;
  final BorderRadius? borderRadius;

  const HunterProgressBar({
    super.key,
    required this.progress,
    this.height = 10.0,
    this.gradient,
    this.backgroundColor = HunterColors.surfaceSecondary,
    this.showGlow = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final radius = borderRadius ?? BorderRadius.circular(height / 2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final fillWidth = totalWidth * clampedProgress;

        return Stack(
          children: [
            // Background track
            Container(
              height: height,
              width: totalWidth,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: radius,
                border: Border.all(
                  color: HunterColors.borderThin,
                  width: 0.5,
                ),
              ),
            ),
            // Progress fill
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              height: height,
              width: fillWidth,
              decoration: BoxDecoration(
                gradient: gradient ?? HunterColors.xpBarGradient,
                borderRadius: radius,
                boxShadow: showGlow
                    ? [
                        BoxShadow(
                          color: HunterColors.cyan.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
