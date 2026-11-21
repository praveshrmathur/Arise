import 'package:flutter/material.dart';
import '../../app/theme/hunter_colors.dart';
import '../../app/theme/hunter_shadows.dart';
import '../../app/theme/hunter_typography.dart';

enum HunterButtonVariant { primary, outline, secondary }

class HunterButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final HunterButtonVariant variant;
  final double? width;
  final double height;

  const HunterButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = HunterButtonVariant.primary,
    this.width,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == HunterButtonVariant.primary
                    ? const Color(0xFF080B12)
                    : HunterColors.cyan,
              ),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: variant == HunterButtonVariant.primary
                  ? const Color(0xFF080B12)
                  : HunterColors.cyan,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: HunterTypography.buttonText.copyWith(
              color: variant == HunterButtonVariant.primary
                  ? const Color(0xFF080B12)
                  : HunterColors.cyan,
            ),
          ),
        ],
      ],
    );

    if (variant == HunterButtonVariant.outline) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: HunterColors.cyan, width: 1.2),
          boxShadow: HunterShadows.cyanGlow(radius: 6),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(12),
            splashColor: HunterColors.cyanGlow,
            child: Center(child: content),
          ),
        ),
      );
    }

    if (variant == HunterButtonVariant.secondary) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: HunterColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: HunterColors.borderThin),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: Text(
                label,
                style: HunterTypography.buttonText.copyWith(
                  color: HunterColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Primary Electric Gradient Button
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: HunterColors.electricButtonGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: HunterShadows.cyanGlow(radius: 12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.white24,
          child: Center(child: content),
        ),
      ),
    );
  }
}
