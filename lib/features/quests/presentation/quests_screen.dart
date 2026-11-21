import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_typography.dart';
import '../../../core/widgets/holographic_card.dart';
import '../../../core/widgets/hunter_app_bar.dart';
import '../../../core/widgets/hunter_progress_bar.dart';
import '../../../core/widgets/system_toast.dart';
import '../../hunter_status/providers/hunter_stats_provider.dart';
import '../models/quest_model.dart';
import '../providers/quest_provider.dart';
import 'quest_detail_modal.dart';
import 'widgets/quest_card.dart';

class QuestsScreen extends ConsumerStatefulWidget {
  const QuestsScreen({super.key});

  @override
  ConsumerState<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends ConsumerState<QuestsScreen> {
  QuestCategory? _selectedCategory;

  void _handleCompleteQuest(QuestModel quest) {
    final success = ref.read(questProvider.notifier).completeQuest(quest.id);
    if (success) {
      SystemToast.show(
        context,
        title: 'Mission Cleared',
        message: '${quest.title} verified by System.',
        xpAwarded: quest.xpReward,
      );
    }
  }

  void _handleSkipQuest(QuestModel quest) {
    ref.read(questProvider.notifier).skipQuest(quest.id);
    SystemToast.show(
      context,
      title: 'Mission Skipped',
      message: 'No penalty applied. Resting is valid progression.',
      isSuccess: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final quests = ref.watch(questProvider);
    final stats = ref.watch(hunterStatsProvider);
    final dailySummary = ref.watch(dailyQuestStatsProvider);

    final filteredQuests = _selectedCategory == null
        ? quests
        : quests.where((q) => q.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: HunterColors.background,
      appBar: HunterAppBar(
        title: 'Daily Missions',
        subtitle: 'System assigned challenges for today',
        rank: stats.rank,
        level: stats.level,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // Daily Progress Summary Card
            HolographicCard(
              hasGlow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DAILY ASSIGNMENT PROGRESS',
                        style: HunterTypography.systemSub.copyWith(
                          color: HunterColors.cyan,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${dailySummary.completed} / ${dailySummary.total} CLEARED',
                        style: HunterTypography.systemSub.copyWith(
                          color: HunterColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  HunterProgressBar(
                    progress: dailySummary.completionRate,
                    height: 8,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Earned: +${dailySummary.earnedXp} XP',
                        style: HunterTypography.bodySmall.copyWith(
                          color: HunterColors.cyan,
                        ),
                      ),
                      Text(
                        'Potential Total: +${dailySummary.totalEarnableXp} XP',
                        style: HunterTypography.bodySmall.copyWith(
                          color: HunterColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Category Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterPill(
                    label: 'ALL',
                    isSelected: _selectedCategory == null,
                    onTap: () => setState(() => _selectedCategory = null),
                  ),
                  ...QuestCategory.values.map((cat) {
                    return _FilterPill(
                      label: cat.name.toUpperCase(),
                      isSelected: _selectedCategory == cat,
                      onTap: () => setState(() => _selectedCategory = cat),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ACTIVE OBJECTIVES (${filteredQuests.length})',
              style: HunterTypography.systemSub,
            ),
            const SizedBox(height: 10),
            if (filteredQuests.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'No missions in this category today.',
                    style: HunterTypography.bodyMedium,
                  ),
                ),
              )
            else
              ...filteredQuests.map((quest) {
                return QuestCard(
                  quest: quest,
                  onTap: () => QuestDetailModal.show(
                    context,
                    quest: quest,
                    onConfirm: () => _handleCompleteQuest(quest),
                    onSkip: () => _handleSkipQuest(quest),
                  ),
                  onComplete: () => _handleCompleteQuest(quest),
                );
              }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? HunterColors.cyan.withOpacity(0.2) : HunterColors.surfacePrimary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? HunterColors.cyan : HunterColors.borderThin,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: HunterTypography.systemSub.copyWith(
              fontSize: 10,
              color: isSelected ? HunterColors.cyan : HunterColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
