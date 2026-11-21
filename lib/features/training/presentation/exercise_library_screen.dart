import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_typography.dart';
import '../../../core/widgets/holographic_card.dart';
import '../../../core/widgets/hunter_app_bar.dart';
import '../models/exercise_model.dart';
import '../providers/workout_provider.dart';

class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  ConsumerState<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen> {
  String _selectedMuscle = 'all';

  @override
  Widget build(BuildContext context) {
    final exercises = ref.watch(exerciseLibraryProvider);

    final filtered = _selectedMuscle == 'all'
        ? exercises
        : exercises.where((e) => e.primaryMuscle.toLowerCase() == _selectedMuscle).toList();

    return Scaffold(
      backgroundColor: HunterColors.background,
      appBar: const HunterAppBar(
        title: 'Exercise Codex',
        subtitle: 'Tactical movement repository',
        showBack: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Muscle group filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  'all',
                  'chest',
                  'back',
                  'legs',
                  'shoulders',
                  'core',
                  'cardio',
                ].map((muscle) {
                  final isSelected = _selectedMuscle == muscle;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _selectedMuscle = muscle),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? HunterColors.cyan.withOpacity(0.18) : HunterColors.surfacePrimary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? HunterColors.cyan : HunterColors.borderThin,
                          ),
                        ),
                        child: Text(
                          muscle.toUpperCase(),
                          style: HunterTypography.systemSub.copyWith(
                            fontSize: 10,
                            color: isSelected ? HunterColors.cyan : HunterColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final ex = filtered[index];
                  return HolographicCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ex.name,
                              style: HunterTypography.displaySmall.copyWith(fontSize: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: HunterColors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: HunterColors.borderThin),
                              ),
                              child: Text(
                                ex.difficulty.toUpperCase(),
                                style: HunterTypography.systemSub.copyWith(
                                  fontSize: 9,
                                  color: HunterColors.cyan,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              'Target: ${ex.primaryMuscle.toUpperCase()}',
                              style: HunterTypography.bodySmall.copyWith(
                                color: HunterColors.cyan,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Gear: ${ex.equipment.replaceAll('_', ' ').toUpperCase()}',
                              style: HunterTypography.bodySmall.copyWith(
                                color: HunterColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ex.instructions,
                          style: HunterTypography.bodySmall.copyWith(
                            color: HunterColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
