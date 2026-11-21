import 'package:flutter/material.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_typography.dart';
import '../../../core/widgets/hunter_button.dart';
import '../models/quest_model.dart';

class QuestDetailModal extends StatelessWidget {
  final QuestModel quest;
  final VoidCallback onConfirm;
  final VoidCallback onSkip;

  const QuestDetailModal({
    super.key,
    required this.quest,
    required this.onConfirm,
    required this.onSkip,
  });

  static Future<void> show(
    BuildContext context, {
    required QuestModel quest,
    required VoidCallback onConfirm,
    required VoidCallback onSkip,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => QuestDetailModal(
        quest: quest,
        onConfirm: () {
          Navigator.pop(context);
          onConfirm();
        },
        onSkip: () {
          Navigator.pop(context);
          onSkip();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: HunterColors.surfacePrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: HunterColors.cyan, width: 1.5),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: HunterColors.borderThin,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '[ MISSION BRIEFING ]',
                  style: HunterTypography.systemTitle.copyWith(fontSize: 13),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: HunterColors.cyan.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '+${quest.xpReward} XP',
                    style: HunterTypography.systemSub.copyWith(
                      color: HunterColors.cyan,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(quest.title, style: HunterTypography.displaySmall),
            const SizedBox(height: 8),
            Text(quest.description, style: HunterTypography.bodyMedium),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text('MISSION PROTOCOL & INSTRUCTIONS', style: HunterTypography.systemSub),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: HunterColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: HunterColors.borderThin),
              ),
              child: Text(
                quest.instructions,
                style: HunterTypography.bodyMedium.copyWith(
                  color: HunterColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MetricItem(
                    label: 'Target',
                    value: '${quest.targetValue} ${quest.unit}',
                  ),
                ),
                Expanded(
                  child: _MetricItem(
                    label: 'Estimated Time',
                    value: '${quest.durationMinutes} min',
                  ),
                ),
                Expanded(
                  child: _MetricItem(
                    label: 'Difficulty',
                    value: quest.difficulty.name.toUpperCase(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            if (!quest.isCompleted && !quest.isSkipped) ...[
              HunterButton(
                label: 'CONFIRM OBJECTIVE COMPLETE',
                onPressed: onConfirm,
              ),
              const SizedBox(height: 12),
              HunterButton(
                label: 'SKIP MISSION (NO PENALTY)',
                variant: HunterButtonVariant.secondary,
                onPressed: onSkip,
              ),
            ] else ...[
              Center(
                child: Text(
                  quest.isCompleted ? 'MISSION OBJECTIVE ALREADY ACCOMPLISHED' : 'MISSION SKIPPED',
                  style: HunterTypography.systemSub.copyWith(
                    color: quest.isCompleted ? HunterColors.success : HunterColors.textMuted,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;

  const _MetricItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: HunterTypography.bodySmall.copyWith(fontSize: 10)),
        const SizedBox(height: 2),
        Text(
          value,
          style: HunterTypography.systemSub.copyWith(
            color: HunterColors.cyan,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
