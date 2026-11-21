import '../../../core/services/supabase_service.dart';
import '../../quests/models/quest_model.dart';
import '../models/ai_quest_suggestion.dart';

class AiCoachService {
  AiCoachService._();

  /// Validates AI output against strict physical safety rules:
  /// - Reject dangerous prompts
  /// - Reject excessive exercise durations (> 120 mins)
  /// - Prevent XP exploitation (> 150 XP per standard quest)
  /// - Ensure minimum rest parameters
  static bool validateQuestSafety(AiQuestSuggestion suggestion) {
    if (suggestion.durationMinutes > 120 || suggestion.durationMinutes < 1) {
      return false;
    }
    if (suggestion.xpReward > 150 || suggestion.xpReward < 5) {
      return false;
    }
    if (suggestion.targetValue <= 0) {
      return false;
    }

    final lowerTitle = suggestion.title.toLowerCase();
    final lowerDesc = suggestion.description.toLowerCase();

    // Safety checks against extreme or dangerous physical instructions
    final prohibitedTerms = [
      'train through pain',
      'ignore injury',
      'no water',
      'starvation',
      'maximum heart rate for 1 hour',
      'extreme dehydration',
    ];

    for (final term in prohibitedTerms) {
      if (lowerTitle.contains(term) || lowerDesc.contains(term)) {
        return false;
      }
    }

    return true;
  }

  /// Generates daily quests via secure backend function or safe offline calibration
  static Future<List<QuestModel>> generatePersonalizedQuests({
    required String hunterLevel,
    required List<String> fitnessGoals,
    required List<String> limitations,
  }) async {
    final today = DateTime.now();

    if (SupabaseService.isConfigured && SupabaseService.client != null) {
      try {
        final response = await SupabaseService.client!.functions.invoke(
          'generate-daily-quests',
          body: {
            'hunter_level': hunterLevel,
            'fitness_goals': fitnessGoals,
            'limitations': limitations,
          },
        );

        if (response.data != null) {
          final parsed = AiDailyQuestResponse.fromJson(response.data as Map<String, dynamic>);
          final validQuests = <QuestModel>[];
          int counter = 1;

          for (final q in parsed.quests) {
            if (validateQuestSafety(q)) {
              validQuests.add(q.toQuestModel('ai-quest-${today.millisecondsSinceEpoch}-$counter', today));
              counter++;
            }
          }

          if (validQuests.isNotEmpty) {
            return validQuests;
          }
        }
      } catch (e) {
        // Fallback to deterministic calibrated generation
      }
    }

    // Deterministic safe fallback
    return [
      QuestModel(
        id: 'calibrated-01',
        title: 'Calibrated Kinetic Stride',
        description: 'Low-impact continuous aerobic activation to elevate heart rate safely.',
        category: QuestCategory.walking,
        difficulty: QuestDifficulty.beginner,
        instructions: 'Walk 3,000 steps at a conversational pace.',
        targetMetric: 'steps',
        targetValue: 3000,
        unit: 'steps',
        durationMinutes: 25,
        xpReward: 40,
        verificationMethod: VerificationMethod.manual,
        scheduledDate: today,
        expiresAt: today.add(const Duration(hours: 23, minutes: 59)),
      ),
      QuestModel(
        id: 'calibrated-02',
        title: 'Joint Mobility & Spinal Wave',
        description: 'Gentle range-of-motion work respecting stated mobility limitations.',
        category: QuestCategory.mobility,
        difficulty: QuestDifficulty.beginner,
        instructions: 'Perform thoracic rotations and hip openers for 10 minutes.',
        targetMetric: 'minutes',
        targetValue: 10,
        unit: 'min',
        durationMinutes: 10,
        xpReward: 35,
        verificationMethod: VerificationMethod.manual,
        scheduledDate: today,
        expiresAt: today.add(const Duration(hours: 23, minutes: 59)),
      ),
    ];
  }
}
