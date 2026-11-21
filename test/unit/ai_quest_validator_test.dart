import 'package:flutter_test/flutter_test.dart';
import 'package:project_hunter/features/ai_coach/models/ai_quest_suggestion.dart';
import 'package:project_hunter/features/ai_coach/services/ai_coach_service.dart';

void main() {
  group('AiCoachService Safety Validator Tests', () {
    test('Valid quest proposal passes safety check', () {
      const valid = AiQuestSuggestion(
        title: 'Calibrated Morning Walk',
        category: 'walking',
        difficulty: 'beginner',
        description: 'Walk for 20 minutes briskly.',
        targetMetric: 'minutes',
        targetValue: 20,
        targetUnit: 'min',
        durationMinutes: 20,
        xpReward: 40,
        verificationMethod: 'manual',
      );

      expect(AiCoachService.validateQuestSafety(valid), isTrue);
    });

    test('Excessive XP claim is rejected', () {
      const excessiveXp = AiQuestSuggestion(
        title: 'Exploit Quest',
        category: 'strength',
        difficulty: 'beginner',
        description: 'Do 5 squats.',
        targetMetric: 'reps',
        targetValue: 5,
        targetUnit: 'reps',
        durationMinutes: 5,
        xpReward: 9999, // Prohibited
        verificationMethod: 'manual',
      );

      expect(AiCoachService.validateQuestSafety(excessiveXp), isFalse);
    });

    test('Dangerous instruction is rejected', () {
      const dangerous = AiQuestSuggestion(
        title: 'Extreme Push',
        category: 'strength',
        difficulty: 'advanced',
        description: 'Train through pain and ignore injury completely.',
        targetMetric: 'reps',
        targetValue: 100,
        targetUnit: 'reps',
        durationMinutes: 45,
        xpReward: 50,
        verificationMethod: 'manual',
      );

      expect(AiCoachService.validateQuestSafety(dangerous), isFalse);
    });
  });
}
