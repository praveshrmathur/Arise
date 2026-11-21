import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_typography.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/holographic_card.dart';
import '../../../core/widgets/hunter_app_bar.dart';
import '../../../core/widgets/hunter_button.dart';
import '../../../core/widgets/system_toast.dart';
import '../providers/workout_provider.dart';
import 'widgets/rest_timer_sheet.dart';

class ActiveWorkoutScreen extends ConsumerWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutProvider);
    final notifier = ref.read(workoutProvider.notifier);

    final session = workoutState.session;

    if (session == null) {
      return Scaffold(
        backgroundColor: HunterColors.background,
        appBar: const HunterAppBar(title: 'Active Session', showBack: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fitness_center_outlined, size: 64, color: HunterColors.textMuted),
              const SizedBox(height: 16),
              Text('NO ACTIVE WORKOUT DETECTED', style: HunterTypography.systemTitle),
              const SizedBox(height: 8),
              Text('Deploy a routine from the Training terminal.', style: HunterTypography.bodyMedium),
              const SizedBox(height: 24),
              HunterButton(
                label: 'RETURN TO SECTOR',
                variant: HunterButtonVariant.outline,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: HunterColors.background,
      appBar: HunterAppBar(
        title: session.title,
        subtitle: 'Duration: ${DateFormatter.formatDuration(session.durationSeconds)}',
        showBack: true,
        actions: [
          TextButton(
            onPressed: () {
              final finished = notifier.finishWorkout();
              if (finished != null) {
                SystemToast.show(
                  context,
                  title: 'Workout Concluded',
                  message: 'Volume: ${finished.totalVolumeKg.toInt()} kg | 100 XP gained.',
                  xpAwarded: 100,
                );
                context.pop();
              }
            },
            child: Text(
              'FINISH',
              style: HunterTypography.systemSub.copyWith(
                color: HunterColors.cyan,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      bottomSheet: workoutState.isRestTimerActive
          ? RestTimerSheet(
              secondsRemaining: workoutState.restSecondsRemaining,
              onDismiss: () => notifier.dismissRestTimer(),
              onAdd30s: () => notifier.startRestTimer(workoutState.restSecondsRemaining + 30),
            )
          : null,
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: session.exercises.length,
          itemBuilder: (context, exIndex) {
            final ex = session.exercises[exIndex];

            return HolographicCard(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ex.exercise.name,
                        style: HunterTypography.displaySmall.copyWith(fontSize: 16),
                      ),
                      Text(
                        ex.exercise.primaryMuscle.toUpperCase(),
                        style: HunterTypography.systemSub.copyWith(
                          fontSize: 10,
                          color: HunterColors.cyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Table Header
                  Row(
                    children: [
                      SizedBox(width: 32, child: Text('SET', style: HunterTypography.statLabel)),
                      Expanded(child: Center(child: Text('KG', style: HunterTypography.statLabel))),
                      Expanded(child: Center(child: Text('REPS', style: HunterTypography.statLabel))),
                      const SizedBox(width: 48, child: Center(child: Icon(Icons.check, size: 14, color: HunterColors.textMuted))),
                    ],
                  ),
                  const Divider(height: 16),
                  // Sets list
                  ...ex.sets.asMap().entries.map((entry) {
                    final setIndex = entry.key;
                    final s = entry.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child: Text(
                              '#${s.setNumber}',
                              style: HunterTypography.systemSub.copyWith(fontSize: 12),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: _QuickNumberBox(
                                value: s.weightKg.toInt().toString(),
                                suffix: 'kg',
                                onIncrement: () => notifier.updateSetValues(
                                  exIndex,
                                  setIndex,
                                  weight: s.weightKg + 2.5,
                                ),
                                onDecrement: () => notifier.updateSetValues(
                                  exIndex,
                                  setIndex,
                                  weight: (s.weightKg - 2.5).clamp(0.0, 500.0),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: _QuickNumberBox(
                                value: s.repetitions.toString(),
                                suffix: 'reps',
                                onIncrement: () => notifier.updateSetValues(
                                  exIndex,
                                  setIndex,
                                  reps: s.repetitions + 1,
                                ),
                                onDecrement: () => notifier.updateSetValues(
                                  exIndex,
                                  setIndex,
                                  reps: (s.repetitions - 1).clamp(1, 100),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 48,
                            child: IconButton(
                              icon: Icon(
                                s.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: s.isCompleted ? HunterColors.success : HunterColors.textMuted,
                              ),
                              onPressed: () => notifier.toggleSetCompletion(exIndex, setIndex),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(Icons.add, size: 16, color: HunterColors.cyan),
                      label: Text(
                        'ADD SET',
                        style: HunterTypography.systemSub.copyWith(
                          color: HunterColors.cyan,
                          fontSize: 11,
                        ),
                      ),
                      onPressed: () => notifier.addSetToExercise(exIndex),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuickNumberBox extends StatelessWidget {
  final String value;
  final String suffix;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuickNumberBox({
    required this.value,
    required this.suffix,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: HunterColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: HunterColors.borderThin),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onDecrement,
            child: const Icon(Icons.remove, size: 14, color: HunterColors.textMuted),
          ),
          Text(
            '$value $suffix',
            style: HunterTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: HunterColors.textPrimary,
            ),
          ),
          InkWell(
            onTap: onIncrement,
            child: const Icon(Icons.add, size: 14, color: HunterColors.cyan),
          ),
        ],
      ),
    );
  }
}
