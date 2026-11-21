import 'package:flutter/material.dart';
import '../../../../app/theme/hunter_colors.dart';
import '../../../../app/theme/hunter_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/hunter_button.dart';

class RestTimerSheet extends StatelessWidget {
  final int secondsRemaining;
  final VoidCallback onDismiss;
  final VoidCallback onAdd30s;

  const RestTimerSheet({
    super.key,
    required this.secondsRemaining,
    required this.onDismiss,
    required this.onAdd30s,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: HunterColors.surfaceElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: const Border(top: BorderSide(color: HunterColors.cyan, width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: HunterColors.cyan.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.timer, color: HunterColors.cyan, size: 22),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SYSTEM RECOVERY WINDOW',
                      style: HunterTypography.systemSub.copyWith(
                        color: HunterColors.cyan,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      DateFormatter.formatDuration(secondsRemaining),
                      style: HunterTypography.displaySmall.copyWith(
                        color: HunterColors.textPrimary,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                HunterButton(
                  label: '+30s',
                  height: 36,
                  variant: HunterButtonVariant.secondary,
                  onPressed: onAdd30s,
                ),
                const SizedBox(width: 8),
                HunterButton(
                  label: 'SKIP REST',
                  height: 36,
                  variant: HunterButtonVariant.outline,
                  onPressed: onDismiss,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
