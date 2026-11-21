import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_typography.dart';
import '../../../core/widgets/holographic_card.dart';
import '../../../core/widgets/hunter_app_bar.dart';
import '../../../core/widgets/hunter_button.dart';
import '../../../core/widgets/hunter_progress_bar.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  final TextEditingController _nameController = TextEditingController(text: 'Hunter');
  final TextEditingController _limitationsController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _limitationsController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final name = _nameController.text.trim().isEmpty ? 'Awakened Hunter' : _nameController.text.trim();
    ref.read(onboardingProvider.notifier).setHunterName(name);
    ref.read(onboardingProvider.notifier).setLimitations(_limitationsController.text.trim());

    await ref.read(authProvider.notifier).completeOnboarding(name);

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      backgroundColor: HunterColors.background,
      appBar: HunterAppBar(
        title: 'Hunter Calibration',
        subtitle: 'Step ${_currentPage + 1} of $_totalPages',
        showBack: _currentPage > 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: HunterProgressBar(
                progress: (_currentPage + 1) / _totalPages,
                height: 6,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  // STEP 1: Identity & Age
                  _buildStepContainer(
                    title: 'SYSTEM REGISTRATION',
                    description: 'Specify your codename and age group for physical calibration.',
                    children: [
                      TextFormField(
                        controller: _nameController,
                        style: HunterTypography.bodyLarge,
                        decoration: const InputDecoration(
                          labelText: 'Hunter Codename',
                          prefixIcon: Icon(Icons.person_pin, color: HunterColors.cyan),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('AGE CATEGORY', style: HunterTypography.systemSub),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: ['Under 20', '20-29', '30-39', '40-49', '50+'].map((age) {
                          final isSelected = onboarding.ageRange == age;
                          return _OptionChip(
                            label: age,
                            isSelected: isSelected,
                            onTap: () => notifier.setAgeRange(age),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  // STEP 2: Goals & Experience
                  _buildStepContainer(
                    title: 'TRAINING DIRECTIVES',
                    description: 'Select your primary directives and past training experience.',
                    children: [
                      Text('EXPERIENCE LEVEL', style: HunterTypography.systemSub),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _OptionChip(
                              label: 'Beginner',
                              isSelected: onboarding.fitnessExperience == 'beginner',
                              onTap: () => notifier.setExperience('beginner'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _OptionChip(
                              label: 'Intermediate',
                              isSelected: onboarding.fitnessExperience == 'intermediate',
                              onTap: () => notifier.setExperience('intermediate'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _OptionChip(
                              label: 'Advanced',
                              isSelected: onboarding.fitnessExperience == 'advanced',
                              onTap: () => notifier.setExperience('advanced'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('DIRECTIVES (SELECT MULTIPLE)', style: HunterTypography.systemSub),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          {'code': 'fat_loss', 'title': 'Fat Loss'},
                          {'code': 'muscle_building', 'title': 'Hypertrophy / Muscle'},
                          {'code': 'strength', 'title': 'Raw Strength'},
                          {'code': 'endurance', 'title': 'Cardio Endurance'},
                          {'code': 'general_fitness', 'title': 'General Vitality'},
                          {'code': 'better_consistency', 'title': 'Discipline & Habits'},
                          {'code': 'improved_mobility', 'title': 'Flexibility & Agility'},
                        ].map((g) {
                          final isSelected = onboarding.fitnessGoals.contains(g['code']);
                          return _OptionChip(
                            label: g['title']!,
                            isSelected: isSelected,
                            onTap: () => notifier.toggleGoal(g['code']!),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  // STEP 3: Environment & Equipment
                  _buildStepContainer(
                    title: 'SECTOR & GEAR',
                    description: 'Where do you deploy and what equipment do you possess?',
                    children: [
                      Text('DEPLOYMENT SECTOR', style: HunterTypography.systemSub),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _OptionChip(
                              label: 'Home Base',
                              isSelected: onboarding.trainingLocation == 'home',
                              onTap: () => notifier.setTrainingLocation('home'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _OptionChip(
                              label: 'Training Gym',
                              isSelected: onboarding.trainingLocation == 'gym',
                              onTap: () => notifier.setTrainingLocation('gym'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _OptionChip(
                              label: 'Both',
                              isSelected: onboarding.trainingLocation == 'both',
                              onTap: () => notifier.setTrainingLocation('both'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('AVAILABLE GEAR', style: HunterTypography.systemSub),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          {'code': 'bodyweight', 'title': 'Bodyweight Only'},
                          {'code': 'dumbbells', 'title': 'Dumbbells'},
                          {'code': 'bands', 'title': 'Resistance Bands'},
                          {'code': 'pull_up_bar', 'title': 'Pull-Up Bar'},
                          {'code': 'barbell', 'title': 'Barbell & Plates'},
                          {'code': 'machines', 'title': 'Full Gym Machines'},
                        ].map((eq) {
                          final isSelected = onboarding.availableEquipment.contains(eq['code']);
                          return _OptionChip(
                            label: eq['title']!,
                            isSelected: isSelected,
                            onTap: () => notifier.toggleEquipment(eq['code']!),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  // STEP 4: Schedule & Safety Limitations
                  _buildStepContainer(
                    title: 'SCHEDULE & LIMITATIONS',
                    description: 'Safe progression: the System will respect injuries and time limits.',
                    children: [
                      Text('TRAINING DAYS PER WEEK: ${onboarding.workoutDaysPerWeek} DAYS',
                          style: HunterTypography.systemSub),
                      Slider(
                        value: onboarding.workoutDaysPerWeek.toDouble(),
                        min: 2,
                        max: 7,
                        divisions: 5,
                        activeColor: HunterColors.cyan,
                        inactiveColor: HunterColors.surfaceSecondary,
                        onChanged: (val) => notifier.setWorkoutSchedule(days: val.toInt()),
                      ),
                      const SizedBox(height: 16),
                      Text('DAILY TIME ALLOCATION: ${onboarding.dailyTimeMinutes} MIN',
                          style: HunterTypography.systemSub),
                      Slider(
                        value: onboarding.dailyTimeMinutes.toDouble(),
                        min: 15,
                        max: 90,
                        divisions: 5,
                        activeColor: HunterColors.cyan,
                        inactiveColor: HunterColors.surfaceSecondary,
                        onChanged: (val) => notifier.setWorkoutSchedule(durationMinutes: val.toInt()),
                      ),
                      const SizedBox(height: 20),
                      Text('HEALTH LIMITATIONS OR INJURIES (OPTIONAL)', style: HunterTypography.systemSub),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _limitationsController,
                        maxLines: 2,
                        style: HunterTypography.bodyMedium,
                        decoration: const InputDecoration(
                          hintText: 'e.g., Lower back stiffness, knee sensitivity, shoulder rehab',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (_currentPage > 0) ...[
                    Expanded(
                      flex: 1,
                      child: HunterButton(
                        label: 'BACK',
                        variant: HunterButtonVariant.secondary,
                        onPressed: _previousPage,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: HunterButton(
                      label: _currentPage == _totalPages - 1 ? 'AWAKEN SYSTEM' : 'PROCEED',
                      onPressed: _nextPage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContainer({
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: HunterTypography.systemTitle),
          const SizedBox(height: 6),
          Text(description, style: HunterTypography.bodyMedium),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? HunterColors.cyan.withOpacity(0.15) : HunterColors.surfacePrimary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? HunterColors.cyan : HunterColors.borderThin,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: HunterTypography.bodySmall.copyWith(
            color: isSelected ? HunterColors.cyan : HunterColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
