import 'package:flutter/material.dart';
import '../../app/theme/hunter_colors.dart';
import '../../app/theme/hunter_shadows.dart';
import '../../app/theme/hunter_typography.dart';

class SystemToast {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    int? xpAwarded,
    bool isSuccess = true,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            builder: (context, val, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * val),
                child: Opacity(
                  opacity: val.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: HunterColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSuccess ? HunterColors.cyan : HunterColors.danger,
                  width: 1.2,
                ),
                boxShadow: isSuccess
                    ? HunterShadows.cyanGlow(radius: 12)
                    : [
                        BoxShadow(
                          color: HunterColors.danger.withOpacity(0.4),
                          blurRadius: 12,
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Icon(
                    isSuccess ? Icons.offline_bolt : Icons.warning_amber_rounded,
                    color: isSuccess ? HunterColors.cyan : HunterColors.danger,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: HunterTypography.systemSub.copyWith(
                            color: isSuccess ? HunterColors.cyan : HunterColors.danger,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          message,
                          style: HunterTypography.bodyMedium.copyWith(
                            color: HunterColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (xpAwarded != null && xpAwarded > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: HunterColors.cyan.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: HunterColors.cyan, width: 0.5),
                      ),
                      child: Text(
                        '+$xpAwarded XP',
                        style: HunterTypography.systemSub.copyWith(
                          color: HunterColors.cyan,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), () {
      entry.remove();
    });
  }
}
