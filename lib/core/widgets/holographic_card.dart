import 'package:flutter/material.dart';
import '../../app/theme/hunter_colors.dart';
import '../../app/theme/hunter_shadows.dart';

/// Holographic RPG Card Widget with illuminated border and futuristic surfaces
class HolographicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final Color? borderColor;
  final bool hasGlow;
  final Gradient? gradient;
  final double borderRadius;

  const HolographicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.borderColor,
    this.hasGlow = false,
    this.gradient,
    this.borderRadius = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final border = Border.all(
      color: borderColor ?? (hasGlow ? HunterColors.cyan : HunterColors.borderThin),
      width: hasGlow ? 1.5 : 1.0,
    );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasGlow ? HunterShadows.cyanGlow(radius: 14) : HunterShadows.subtleCard,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: HunterColors.cyanGlow,
          highlightColor: Colors.transparent,
          child: Ink(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: border,
              gradient: gradient ?? HunterColors.cardGradient,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
