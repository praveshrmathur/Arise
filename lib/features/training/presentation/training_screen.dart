import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_typography.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/holographic_card.dart';
import '../../../core/widgets/hunter_app_bar.dart';
import '../../../core/widgets/hunter_button.dart';
import '../../hunter_status/providers/hunter_stats_provider.dart';
import '../providers/workout_provider.dart';

class TrainingScreen extends ConsumerWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutProvider);
    final stats = ref.watch(hunterStatsProvider);
    final exercises = ref.watch(exerciseLibraryProvider);
    final notifier = ref.read(workoutProvider.notifier);

    return Scaffold(
      backgroundColor: HunterColors.background,
      appBar: HunterAppBar(
        title: 'Training Chamber',
        subtitle: 'Physical conditioning & resistance tracking',
        rank: stats.rank,
        level: stats.level,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // Active session banner if in progress
            if (workoutState.hasActiveSession) ...[
              HolographicCard(
                hasGlow: true,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: HunterColors.cyanGlow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.flash_on, color: HunterColors.cyan, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('WORKOUT IN PROGRESS', style: HunterTypography.systemSub),
                          const SizedBox(height: 2),
                          Text(
                            workoutState.session!.title,
                            style: HunterTypography.displaySmall.copyWith(fontSize: 16),
                          ),
                          Text(
                            DateFormatter.formatDuration(workoutState.session!.durationSeconds),
                            style: HunterTypography.bodySmall.copyWith(color: HunterColors.cyan),
                          ),
                        ],
                      ),
                    ),
                    HunterButton(
                      label: 'RESUME',
                      height: 38,
                      onPressed: () => context.push('/training/active'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TRAINING PROTOCOLS', style: HunterTypography.systemSub),
                TextButton.icon(
                  onPressed: () => context.push('/training/exercises'),
                  icon: const Icon(Icons.menu_book_outlined, size: 16, color: HunterColors.cyan),
                  label: Text(
                    'EXERCISE CODEX',
                    style: HunterTypography.systemSub.copyWith(
                      color: HunterColors.cyan,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Pre-built Training Protocols
            _ProtocolCard(
              title: 'Full Body Awakening',
              duration: '35 min',
              category: 'Strength & Hypertrophy',
              xpReward: 100,
              icon: Icons.fitness_center,
              onStart: () {
                notifier.startWorkout('Full Body Awakening', [
                  exercises[0], // Push up
                  exercises[2], // Squat
                  exercises[6], // Plank
                ]);
                context.push('/training/active');
              },
            ),
            const SizedBox(height: 12),
            _ProtocolCard(
              title: 'Upper Torso Fortification',
              duration: '40 min',
              category: 'Chest, Back & Shoulders',
              xpReward: 100,
              icon: Icons.shield,
              onStart: () {
                notifier.startWorkout('Upper Torso Fortification', [
                  exercises[0], // Push up
                  exercises[1], // Pull up
                  exercises[3], // DB Bench Press
                  exercises[5], // DB Shoulder Press
                ]);
                context.push('/training/active');
              },
            ),
            const SizedBox(height: 12),
            _ProtocolCard(
              title: 'Kinetic Agility & Mobility Flow',
              duration: '20 min',
              category: 'Decompression & Agility',
              xpReward: 80,
              icon: Icons.self_improvement,
              onStart: () {
                notifier.startWorkout('Kinetic Agility Flow', [
                  exercises[8], // Cat cow
                  exercises[6], // Plank
                ]);
                context.push('/training/active');
              },
            ),

            const SizedBox(height: 24),
            Text('TRAINING RECORD ARCHIVE', style: HunterTypography.systemSub),
            const SizedBox(height: 10),
            if (notifier.history.isEmpty)
              HolographicCard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const Icon(Icons.history, color: HunterColors.textMuted, size: 36),
                        const SizedBox(height: 8),
                        Text('No completed logs in current session.', style: HunterTypography.bodyMedium),
                        Text(
                          'Execute your first routine above to record volume & personal records.',
                          style: HunterTypography.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...notifier.history.map((h) {
                return HolographicCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(h.title, style: HunterTypography.displaySmall.copyWith(fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(
                            'Duration: ${DateFormatter.formatDuration(h.durationSeconds)} | Volume: ${h.totalVolumeKg.toInt()} kg',
                            style: HunterTypography.bodySmall,
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
                          '+${h.xpEarned} XP',
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

class _ProtocolCard extends StatelessWidget {
  final String title;
  final String duration;
  final String category;
  final int xpReward;
  final IconData icon;
  final VoidCallback onStart;

  const _ProtocolCard({
    required this.title,
    required this.duration,
    required this.category,
    required this.xpReward,
    required this.icon,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return HolographicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: HunterColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: HunterColors.borderThin),
                ),
                child: Icon(icon, color: HunterColors.cyan, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.toUpperCase(), style: HunterTypography.systemSub.copyWith(fontSize: 10)),
                    const SizedBox(height: 2),
                    Text(title, style: HunterTypography.displaySmall.copyWith(fontSize: 15)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: HunterColors.cyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: HunterColors.cyan.withOpacity(0.3)),
                ),
                child: Text(
                  '+$xpReward XP',
                  style: HunterTypography.systemSub.copyWith(
                    color: HunterColors.cyan,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 14, color: HunterColors.textMuted),
                  const SizedBox(width: 4),
                  Text(duration, style: HunterTypography.bodySmall),
                ],
              ),
              HunterButton(
                label: 'DEPLOY PROTOCOL',
                height: 36,
                onPressed: onStart,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
