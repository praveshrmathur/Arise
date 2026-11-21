import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_typography.dart';
import '../../../core/constants/rank_constants.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/attribute_hexagon.dart';
import '../../../core/widgets/holographic_card.dart';
import '../../../core/widgets/hunter_app_bar.dart';
import '../../../core/widgets/hunter_progress_bar.dart';
import '../../../core/widgets/rank_badge.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/hunter_stats_provider.dart';

class HunterStatusScreen extends ConsumerWidget {
  const HunterStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(hunterStatsProvider);
    final authState = ref.watch(authProvider);
    final notifier = ref.read(hunterStatsProvider.notifier);
    final user = authState.user;

    final progress = stats.progress;
    final nextRank = stats.rank.nextRank;

    return Scaffold(
      backgroundColor: HunterColors.background,
      appBar: HunterAppBar(
        title: 'Hunter Status Window',
        subtitle: 'Biometric stats & power parameters',
        rank: stats.rank,
        level: stats.level,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // Status Window Monolith
            HolographicCard(
              hasGlow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RankBadge(rank: stats.rank, size: 54, showTitle: true),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('HUNTER IDENTITY', style: HunterTypography.systemSub.copyWith(fontSize: 10)),
                          const SizedBox(height: 2),
                          Text(
                            user?.hunterName ?? 'Shadow Hunter',
                            style: HunterTypography.displaySmall.copyWith(fontSize: 17),
                          ),
                          Text(
                            'LEVEL ${stats.level}',
                            style: HunterTypography.systemTitle.copyWith(fontSize: 13, color: HunterColors.cyan),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Level & XP Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EXPERIENCE (XP)',
                        style: HunterTypography.systemSub.copyWith(fontSize: 11),
                      ),
                      Text(
                        '${progress.currentLevelXp} / ${progress.xpForNextLevel} XP',
                        style: HunterTypography.systemSub.copyWith(
                          color: HunterColors.cyan,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  HunterProgressBar(
                    progress: progress.progressPercent,
                    height: 10,
                  ),
                  const SizedBox(height: 8),
                  if (nextRank != null)
                    Text(
                      'Next Rank: ${nextRank.title} (Requires Level ${nextRank.minLevel})',
                      style: HunterTypography.bodySmall.copyWith(
                        color: HunterColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Character Attributes: STR, AGI, VIT, END, DIS
            Text('CORE BIOMETRIC ATTRIBUTES', style: HunterTypography.systemSub),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.8,
              children: [
                AttributeStatCard(
                  label: 'Strength (Power)',
                  code: 'STR',
                  value: stats.strength,
                  progress: (stats.strength / 100).clamp(0.0, 1.0),
                  icon: Icons.fitness_center,
                  accentColor: const Color(0xFFEF4444),
                ),
                AttributeStatCard(
                  label: 'Agility (Movement)',
                  code: 'AGI',
                  value: stats.agility,
                  progress: (stats.agility / 100).clamp(0.0, 1.0),
                  icon: Icons.directions_run,
                  accentColor: HunterColors.cyan,
                ),
                AttributeStatCard(
                  label: 'Vitality (Recovery)',
                  code: 'VIT',
                  value: stats.vitality,
                  progress: (stats.vitality / 100).clamp(0.0, 1.0),
                  icon: Icons.favorite,
                  accentColor: HunterColors.success,
                ),
                AttributeStatCard(
                  label: 'Endurance (Stamina)',
                  code: 'END',
                  value: stats.endurance,
                  progress: (stats.endurance / 100).clamp(0.0, 1.0),
                  icon: Icons.speed,
                  accentColor: const Color(0xFFF97316),
                ),
                AttributeStatCard(
                  label: 'Discipline (Consistency)',
                  code: 'DIS',
                  value: stats.discipline,
                  progress: (stats.discipline / 100).clamp(0.0, 1.0),
                  icon: Icons.military_tech,
                  accentColor: const Color(0xFFA855F7),
                ),
                // Overview metrics
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: HunterColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: HunterColors.borderThin),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ACTIVE STREAK', style: HunterTypography.systemSub.copyWith(fontSize: 10)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: HunterColors.warning, size: 20),
                          const SizedBox(width: 4),
                          Text('${stats.currentStreak} DAYS', style: HunterTypography.displaySmall.copyWith(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // XP Transaction Audit Log
            Text('XP TRANSACTION AUDIT LOG', style: HunterTypography.systemSub),
            const SizedBox(height: 10),
            if (notifier.xpHistory.isEmpty)
              HolographicCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text('No transactions recorded yet.', style: HunterTypography.bodySmall),
                  ),
                ),
              )
            else
              ...notifier.xpHistory.take(5).map((tx) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: HunterColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: HunterColors.borderThin),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.reason,
                            style: HunterTypography.bodyMedium.copyWith(
                              color: HunterColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            DateFormatter.formatShortDate(tx.createdAt),
                            style: HunterTypography.bodySmall.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: HunterColors.cyan.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '+${tx.amount} XP',
                          style: HunterTypography.systemSub.copyWith(
                            color: HunterColors.cyan,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
