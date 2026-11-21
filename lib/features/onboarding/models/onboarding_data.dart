class OnboardingData {
  final String hunterName;
  final String ageRange;
  final String fitnessExperience; // beginner, intermediate, advanced
  final List<String> fitnessGoals;
  final double? heightCm;
  final double? weightKg;
  final String activityLevel; // sedentary, light, moderate, active
  final String trainingLocation; // home, gym, both
  final List<String> availableEquipment;
  final int workoutDaysPerWeek;
  final int dailyTimeMinutes;
  final String? limitationsNotes;

  const OnboardingData({
    this.hunterName = '',
    this.ageRange = '25-34',
    this.fitnessExperience = 'beginner',
    this.fitnessGoals = const ['general_fitness', 'better_consistency'],
    this.heightCm,
    this.weightKg,
    this.activityLevel = 'moderate',
    this.trainingLocation = 'both',
    this.availableEquipment = const ['bodyweight', 'dumbbells'],
    this.workoutDaysPerWeek = 4,
    this.dailyTimeMinutes = 30,
    this.limitationsNotes,
  });

  OnboardingData copyWith({
    String? hunterName,
    String? ageRange,
    String? fitnessExperience,
    List<String>? fitnessGoals,
    double? heightCm,
    double? weightKg,
    String? activityLevel,
    String? trainingLocation,
    List<String>? availableEquipment,
    int? workoutDaysPerWeek,
    int? dailyTimeMinutes,
    String? limitationsNotes,
  }) {
    return OnboardingData(
      hunterName: hunterName ?? this.hunterName,
      ageRange: ageRange ?? this.ageRange,
      fitnessExperience: fitnessExperience ?? this.fitnessExperience,
      fitnessGoals: fitnessGoals ?? this.fitnessGoals,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      trainingLocation: trainingLocation ?? this.trainingLocation,
      availableEquipment: availableEquipment ?? this.availableEquipment,
      workoutDaysPerWeek: workoutDaysPerWeek ?? this.workoutDaysPerWeek,
      dailyTimeMinutes: dailyTimeMinutes ?? this.dailyTimeMinutes,
      limitationsNotes: limitationsNotes ?? this.limitationsNotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hunter_name': hunterName,
      'age_range': ageRange,
      'fitness_experience': fitnessExperience,
      'fitness_goals': fitnessGoals,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'activity_level': activityLevel,
      'training_location': trainingLocation,
      'available_equipment': availableEquipment,
      'workout_days_per_week': workoutDaysPerWeek,
      'daily_time_minutes': dailyTimeMinutes,
      'limitations_notes': limitationsNotes,
    };
  }
}
