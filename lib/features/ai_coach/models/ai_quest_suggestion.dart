import '../../quests/models/quest_model.dart';

class AiDailyQuestResponse {
  final String date;
  final String dailyMessage;
  final List<AiQuestSuggestion> quests;

  const AiDailyQuestResponse({
    required this.date,
    required this.dailyMessage,
    required this.quests,
  });

  factory AiDailyQuestResponse.fromJson(Map<String, dynamic> json) {
    return AiDailyQuestResponse(
      date: json['date'] as String,
      dailyMessage: json['daily_message'] as String? ?? 'Your daily assignments have been calibrated.',
      quests: (json['quests'] as List)
          .map((q) => AiQuestSuggestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AiQuestSuggestion {
  final String title;
  final String category;
  final String difficulty;
  final String description;
  final String targetMetric;
  final int targetValue;
  final String targetUnit;
  final int durationMinutes;
  final int xpReward;
  final String verificationMethod;

  const AiQuestSuggestion({
    required this.title,
    required this.category,
    required this.difficulty,
    required this.description,
    required this.targetMetric,
    required this.targetValue,
    required this.targetUnit,
    required this.durationMinutes,
    required this.xpReward,
    required this.verificationMethod,
  });

  factory AiQuestSuggestion.fromJson(Map<String, dynamic> json) {
    return AiQuestSuggestion(
      title: json['title'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String? ?? 'beginner',
      description: json['description'] as String,
      targetMetric: json['target_metric'] as String? ?? 'reps',
      targetValue: json['target_value'] as int? ?? 10,
      targetUnit: json['target_unit'] as String? ?? 'reps',
      durationMinutes: json['duration_minutes'] as int? ?? 15,
      xpReward: (json['xp_reward'] as int? ?? 40).clamp(10, 150),
      verificationMethod: json['verification_method'] as String? ?? 'manual',
    );
  }

  QuestModel toQuestModel(String id, DateTime date) {
    return QuestModel(
      id: id,
      title: title,
      description: description,
      category: QuestCategory.values.firstWhere(
        (c) => c.name.toLowerCase() == category.toLowerCase(),
        orElse: () => QuestCategory.strength,
      ),
      difficulty: QuestDifficulty.values.firstWhere(
        (d) => d.name.toLowerCase() == difficulty.toLowerCase(),
        orElse: () => QuestDifficulty.beginner,
      ),
      instructions: description,
      targetMetric: targetMetric,
      targetValue: targetValue,
      unit: targetUnit,
      durationMinutes: durationMinutes,
      xpReward: xpReward,
      verificationMethod: VerificationMethod.values.firstWhere(
        (v) => v.name.toLowerCase() == verificationMethod.toLowerCase(),
        orElse: () => VerificationMethod.manual,
      ),
      scheduledDate: date,
      expiresAt: date.add(const Duration(hours: 23, minutes: 59)),
    );
  }
}
