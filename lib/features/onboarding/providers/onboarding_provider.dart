import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/onboarding_data.dart';

class OnboardingNotifier extends StateNotifier<OnboardingData> {
  OnboardingNotifier() : super(const OnboardingData());

  void setHunterName(String name) => state = state.copyWith(hunterName: name);
  void setAgeRange(String ageRange) => state = state.copyWith(ageRange: ageRange);
  void setExperience(String experience) => state = state.copyWith(fitnessExperience: experience);
  
  void toggleGoal(String goal) {
    final currentGoals = List<String>.from(state.fitnessGoals);
    if (currentGoals.contains(goal)) {
      if (currentGoals.length > 1) {
        currentGoals.remove(goal);
      }
    } else {
      currentGoals.add(goal);
    }
    state = state.copyWith(fitnessGoals: currentGoals);
  }

  void setBiometrics({double? heightCm, double? weightKg}) {
    state = state.copyWith(heightCm: heightCm, weightKg: weightKg);
  }

  void setActivityLevel(String level) => state = state.copyWith(activityLevel: level);
  void setTrainingLocation(String loc) => state = state.copyWith(trainingLocation: loc);

  void toggleEquipment(String item) {
    final current = List<String>.from(state.availableEquipment);
    if (current.contains(item)) {
      if (current.length > 1) current.remove(item);
    } else {
      current.add(item);
    }
    state = state.copyWith(availableEquipment: current);
  }

  void setWorkoutSchedule({int? days, int? durationMinutes}) {
    state = state.copyWith(
      workoutDaysPerWeek: days ?? state.workoutDaysPerWeek,
      dailyTimeMinutes: durationMinutes ?? state.dailyTimeMinutes,
    );
  }

  void setLimitations(String? notes) => state = state.copyWith(limitationsNotes: notes);
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingData>((ref) {
  return OnboardingNotifier();
});
