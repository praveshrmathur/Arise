import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_typography.dart';
import '../../../core/constants/rank_constants.dart';
import '../../../core/widgets/attribute_hexagon.dart';
import '../../../core/widgets/holographic_card.dart';
import '../../../core/widgets/hunter_app_bar.dart';
import '../../../core/widgets/hunter_button.dart';
import '../../../core/widgets/hunter_progress_bar.dart';
import '../../../core/widgets/rank_badge.dart';
import '../../../core/widgets/system_toast.dart';
import '../../auth/providers/auth_provider.dart';
import '../../hunter_status/providers/hunter_stats_provider.dart';
import '../../quests/models/quest_model.dart';
import '../../quests/presentation/widgets/quest_card.dart';
import '../../quests/providers/quest_provider.dart';
import '../../training/providers/workout_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final stats = ref.watch(hunterStatsProvider);
    final quests = ref.watch(questProvider);
    final dailySummary = ref.watch(dailyQuestStatsProvider);
    final exercises = ref.watch(exerciseLibraryProvider);
    final workoutNotifier = ref.read(workoutProvider.notifier);

    final user = authState.user;
    final progress = stats.progress;
    final pendingQuests = quests.where((q) => q.isPending).take(3).toList();

    return Scaffold(
      backgroundColor: HunterColors.background,
      appBar: HunterAppBar(
        title: 'Hunter Terminal',
        subtitle: 'System Online // Biometric Link Active',
        rank: stats.rank,
        level: stats.level,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: HunterColors.cyan),
            onPressed: () {
              SystemToast.show(
                context,
                title: 'System Notice',
                message: 'All monitoring daemons operational.',
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: HunterColors.cyan,
          backgroundColor: HunterColors.surfacePrimary,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
            if (context.mounted) {
              SystemToast.show(
                context,
                title: 'System Synced',
                message: 'Quests and parameters synchronized.',
              );
            }
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              // A & B: Hunter Profile & Progression Monolith
              HolographicCard(
                hasGlow: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RankBadge(rank: stats.rank, size: 50, showTitle: true),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              user?.hunterName ?? 'Awakened Hunter',
                              style: HunterTypography.displaySmall.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: HunterColors.cyan.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: HunterColors.cyan, width: 0.8),
                              ),
                              child: Text(
                                'LEVEL ${stats.level}',
                                style: HunterTypography.systemSub.copyWith(
                                  color: HunterColors.cyan,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('LEVEL PROGRESS', style: HunterTypography.systemSub.copyWith(fontSize: 10)),
                        Text(
                          '${progress.currentLevelXp} / ${progress.xpForNextLevel} XP',
                          style: HunterTypography.systemSub.copyWith(
                            color: HunterColors.cyan,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    HunterProgressBar(
                      progress: progress.progressPercent,
                      height: 8,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total XP: ${stats.totalXp}',
                          style: HunterTypography.bodySmall.copyWith(color: HunterColors.textMuted),
                        ),
                        Text(
                          'Daily Completion: ${(dailySummary.completionRate * 100).toInt()}%',
                          style: HunterTypography.bodySmall.copyWith(color: HunterColors.cyan),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // F: Quick Actions Grid
              Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      label: 'DEPLOY WORKOUT',
                      icon: Icons.fitness_center,
                      onTap: () {
                        workoutNotifier.startWorkout('Rapid Conditioning', [
                          exercises[0],
                          exercises[2],
                        ]);
                        context.push('/training/active');
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionButton(
                      label: 'VIEW MISSIONS',
                      icon: Icons.assignment_turned_in_outlined,
                      onTap: () => context.go('/quests'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionButton(
                      label: 'STATUS SHEET',
                      icon: Icons.person_search_outlined,
                      onTap: () => context.go('/status'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // C: Daily Progress & Consistency Summary
              Row(
                children: [
                  Expanded(
                    child: HolographicCard(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CLEARED TODAY', style: HunterTypography.systemSub.copyWith(fontSize: 9)),
                          const SizedBox(height: 4),
                          Text(
                            '${dailySummary.completed} / ${dailySummary.total}',
                            style: HunterTypography.displaySmall.copyWith(fontSize: 18),
                          ),
                          Text(
                            '+${dailySummary.earnedXp} XP Collected',
                            style: HunterTypography.bodySmall.copyWith(color: HunterColors.success, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: HolographicCard(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DISCIPLINE STREAK', style: HunterTypography.systemSub.copyWith(fontSize: 9)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.local_fire_department, color: HunterColors.warning, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '${stats.currentStreak} DAYS',
                                style: HunterTypography.displaySmall.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                          Text(
                            'Streak multiplier active',
                            style: HunterTypography.bodySmall.copyWith(color: HunterColors.textMuted, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // D: Character Attributes Preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('BIOMETRIC PARAMETERS', style: HunterTypography.systemSub),
                  GestureDetector(
                    onTap: () => context.go('/status'),
                    child: Text(
                      'FULL DETAILS →',
                      style: HunterTypography.systemSub.copyWith(color: HunterColors.cyan, fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AttributeStatCard(
                      label: 'Strength',
                      code: 'STR',
                      value: stats.strength,
                      progress: (stats.strength / 100).clamp(0.0, 1.0),
                      icon: Icons.fitness_center,
                      accentColor: const Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AttributeStatCard(
                      label: 'Agility',
                      code: 'AGI',
                      value: stats.agility,
                      progress: (stats.agility / 100).clamp(0.0, 1.0),
                      icon: Icons.directions_run,
                      accentColor: HunterColors.cyan,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AttributeStatCard(
                      label: 'Endurance',
                      code: 'END',
                      value: stats.endurance,
                      progress: (stats.endurance / 100).clamp(0.0, 1.0),
                      icon: Icons.speed,
                      accentColor: const Color(0xFFF97316),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // E: Active Missions (Today's priority quests)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PENDING MISSIONS (${pendingQuests.length})', style: HunterTypography.systemSub),
                  GestureDetector(
                    onTap: () => context.go('/quests'),
                    child: Text(
                      'ALL MISSIONS →',
                      style: HunterTypography.systemSub.copyWith(color: HunterColors.cyan, fontSize: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (pendingQuests.isEmpty)
                HolographicCard(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          const Icon(Icons.verified, color: HunterColors.success, size: 36),
                          const SizedBox(height: 8),
                          Text('ALL MISSIONS COMPLETED', style: HunterTypography.systemTitle),
                          Text(
                            'Outstanding dedication. Rest and recover for tomorrow’s system assignment.',
                            style: HunterTypography.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ...pendingQuests.map((quest) {
                  return QuestCard(
                    quest: quest,
                    onTap: () => context.go('/quests'),
                    onComplete: () {
                      final success = ref.read(questProvider.notifier).completeQuest(quest.id);
                      if (success) {
                        SystemToast.show(
                          context,
                          title: 'Mission Cleared',
                          message: '${quest.title} verified by System.',
                          xpAwarded: quest.xpReward,
                        );
                      }
                    },
                  );
                }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: HunterColors.surfacePrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: HunterColors.cyan.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: HunterColors.cyan, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: HunterTypography.systemSub.copyWith(
                fontSize: 8,
                color: HunterColors.textPrimary,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
