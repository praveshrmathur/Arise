import 'package:flutter/material.dart';
import '../../../../app/theme/hunter_colors.dart';
import '../../../../app/theme/hunter_typography.dart';
import '../../../../core/widgets/holographic_card.dart';
import '../../models/quest_model.dart';

class QuestCard extends StatelessWidget {
  final QuestModel quest;
  final VoidCallback onTap;
  final VoidCallback onComplete;

  const QuestCard({
    super.key,
    required this.quest,
    required this.onTap,
    required this.onComplete,
  });

  Color _getCategoryColor(QuestCategory category) {
    switch (category) {
      case QuestCategory.strength:
        return const Color(0xFFEF4444);
      case QuestCategory.cardio:
        return const Color(0xFFF97316);
      case QuestCategory.walking:
        return HunterColors.cyan;
      case QuestCategory.mobility:
        return const Color(0xFFA855F7);
      case QuestCategory.recovery:
      case QuestCategory.hydration:
        return HunterColors.success;
      case QuestCategory.consistency:
      case QuestCategory.discipline:
        return HunterColors.electricBlue;
    }
  }

  IconData _getCategoryIcon(QuestCategory category) {
    switch (category) {
      case QuestCategory.strength:
        return Icons.fitness_center;
      case QuestCategory.cardio:
        return Icons.directions_run;
      case QuestCategory.walking:
        return Icons.directions_walk;
      case QuestCategory.mobility:
        return Icons.self_improvement;
      case QuestCategory.recovery:
        return Icons.bedtime;
      case QuestCategory.hydration:
        return Icons.water_drop;
      case QuestCategory.consistency:
      case QuestCategory.discipline:
        return Icons.verified;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _getCategoryColor(quest.category);
    final catIcon = _getCategoryIcon(quest.category);

    return HolographicCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 12),
      borderColor: quest.isCompleted
          ? HunterColors.success.withOpacity(0.4)
          : quest.isSkipped
              ? HunterColors.borderThin
              : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: catColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: catColor.withOpacity(0.3), width: 1),
                ),
                child: Icon(catIcon, color: catColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.category.name.toUpperCase(),
                      style: HunterTypography.systemSub.copyWith(
                        color: catColor,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      quest.title,
                      style: HunterTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
                        color: quest.isCompleted
                            ? HunterColors.textMuted
                            : HunterColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: HunterColors.cyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: HunterColors.cyan.withOpacity(0.4), width: 0.8),
                ),
                child: Text(
                  '+${quest.xpReward} XP',
                  style: HunterTypography.systemSub.copyWith(
                    color: HunterColors.cyan,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            quest.description,
            style: HunterTypography.bodySmall.copyWith(
              color: HunterColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 14, color: HunterColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    '${quest.durationMinutes}m',
                    style: HunterTypography.bodySmall.copyWith(color: HunterColors.textMuted),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.bolt, size: 14, color: HunterColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    '${quest.targetValue} ${quest.unit}',
                    style: HunterTypography.bodySmall.copyWith(color: HunterColors.textMuted),
                  ),
                ],
              ),
              if (quest.isCompleted)
                Row(
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: HunterColors.success),
                    const SizedBox(width: 4),
                    Text(
                      'CLEARED',
                      style: HunterTypography.systemSub.copyWith(
                        color: HunterColors.success,
                        fontSize: 11,
                      ),
                    ),
                  ],
                )
              else if (quest.isSkipped)
                Text(
                  'SKIPPED',
                  style: HunterTypography.systemSub.copyWith(
                    color: HunterColors.textMuted,
                    fontSize: 11,
                  ),
                )
              else
                InkWell(
                  onTap: onComplete,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: HunterColors.cyan.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: HunterColors.cyan, width: 1),
                    ),
                    child: Text(
                      'CONFIRM CLEAR',
                      style: HunterTypography.systemSub.copyWith(
                        color: HunterColors.cyan,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
