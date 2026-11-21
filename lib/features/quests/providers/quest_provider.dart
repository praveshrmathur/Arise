import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../hunter_status/providers/hunter_stats_provider.dart';
import '../models/quest_model.dart';

class QuestNotifier extends StateNotifier<List<QuestModel>> {
  final Ref _ref;

  QuestNotifier(this._ref) : super(_generateInitialQuests());

  static List<QuestModel> _generateInitialQuests() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      QuestModel(
        id: 'quest-001',
        title: 'Awakening Repetitions',
        description: 'Complete push-ups or assisted incline push-ups with disciplined tempo.',
        category: QuestCategory.strength,
        difficulty: QuestDifficulty.beginner,
        instructions: 'Perform 3 sets of 10 clean repetitions. Keep core engaged and spine neutral.',
        targetMetric: 'reps',
        targetValue: 30,
        unit: 'reps',
        durationMinutes: 12,
        xpReward: 60,
        verificationMethod: VerificationMethod.manual,
        scheduledDate: today,
        expiresAt: today.add(const Duration(hours: 23, minutes: 59)),
      ),
      QuestModel(
        id: 'quest-002',
        title: 'Shadow Stride Exploration',
        description: 'Accumulate outdoor walking or treadmill steps to raise your agility attribute.',
        category: QuestCategory.walking,
        difficulty: QuestDifficulty.beginner,
        instructions: 'Walk continuously at a brisk pace. Listen to an audio log or focus on breathing.',
        targetMetric: 'steps',
        targetValue: 4000,
        unit: 'steps',
        durationMinutes: 30,
        xpReward: 50,
        verificationMethod: VerificationMethod.healthConnect,
        scheduledDate: today,
        expiresAt: today.add(const Duration(hours: 23, minutes: 59)),
      ),
      QuestModel(
        id: 'quest-003',
        title: 'Core Fortification Protocol',
        description: 'Hold front plank intervals to strengthen the pelvic girdle and deep stabilizers.',
        category: QuestCategory.strength,
        difficulty: QuestDifficulty.intermediate,
        instructions: '3 rounds of 30-second plank holds with 30-second rests.',
        targetMetric: 'seconds',
        targetValue: 90,
        unit: 'seconds',
        durationMinutes: 10,
        xpReward: 45,
        verificationMethod: VerificationMethod.manual,
        scheduledDate: today,
        expiresAt: today.add(const Duration(hours: 23, minutes: 59)),
      ),
      QuestModel(
        id: 'quest-004',
        title: 'Cellular Hydration Refill',
        description: 'Drink optimal water throughout the active hours to maintain cellular vitality.',
        category: QuestCategory.hydration,
        difficulty: QuestDifficulty.beginner,
        instructions: 'Consume at least 2.0 liters of pure water across the day.',
        targetMetric: 'milliliters',
        targetValue: 2000,
        unit: 'ml',
        durationMinutes: 5,
        xpReward: 30,
        verificationMethod: VerificationMethod.manual,
        scheduledDate: today,
        expiresAt: today.add(const Duration(hours: 23, minutes: 59)),
      ),
      QuestModel(
        id: 'quest-005',
        title: 'Kinetic Recovery & Thoracic Flow',
        description: 'Decompress hips, hamstrings, and thoracic spine with deep nasal breathing.',
        category: QuestCategory.mobility,
        difficulty: QuestDifficulty.beginner,
        instructions: 'Perform child pose, world greatest stretch, and cat-cow for 8 minutes.',
        targetMetric: 'minutes',
        targetValue: 8,
        unit: 'min',
        durationMinutes: 8,
        xpReward: 35,
        verificationMethod: VerificationMethod.manual,
        scheduledDate: today,
        expiresAt: today.add(const Duration(hours: 23, minutes: 59)),
      ),
    ];
  }

  /// Completes a quest, awards XP, and prevents duplicate submissions
  bool completeQuest(String questId) {
    final index = state.indexWhere((q) => q.id == questId);
    if (index == -1) return false;

    final quest = state[index];
    if (quest.status == QuestStatus.completed) {
      // Already completed - prevent duplicate rewards
      return false;
    }

    final updated = quest.copyWith(
      status: QuestStatus.completed,
      completedAt: DateTime.now(),
    );

    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updated else state[i],
    ];

    // Award XP via HunterStatsNotifier
    _ref.read(hunterStatsProvider.notifier).awardXp(
          amount: quest.xpReward,
          reason: 'Mission: ${quest.title}',
          category: quest.category.name,
        );

    return true;
  }

  /// Skips a quest without penalty
  void skipQuest(String questId) {
    final index = state.indexWhere((q) => q.id == questId);
    if (index == -1) return;

    final quest = state[index];
    if (quest.status == QuestStatus.completed) return;

    final updated = quest.copyWith(status: QuestStatus.skipped);
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updated else state[i],
    ];
  }

  /// Injects newly generated quests (e.g. from AI Engine)
  void addQuests(List<QuestModel> newQuests) {
    state = [...state, ...newQuests];
  }
}

final questProvider =
    StateNotifierProvider<QuestNotifier, List<QuestModel>>((ref) {
  return QuestNotifier(ref);
});

// Computed Daily Completion Percentage
final dailyQuestStatsProvider = Provider((ref) {
  final quests = ref.watch(questProvider);
  if (quests.isEmpty) {
    return const QuestDailySummary(
      total: 0,
      completed: 0,
      completionRate: 0.0,
      totalEarnableXp: 0,
      earnedXp: 0,
    );
  }

  final completed = quests.where((q) => q.isCompleted).length;
  final earnedXp = quests.where((q) => q.isCompleted).fold<int>(0, (sum, q) => sum + q.xpReward);
  final totalEarnableXp = quests.fold<int>(0, (sum, q) => sum + q.xpReward);

  return QuestDailySummary(
    total: quests.length,
    completed: completed,
    completionRate: completed / quests.length,
    totalEarnableXp: totalEarnableXp,
    earnedXp: earnedXp,
  );
});

class QuestDailySummary {
  final int total;
  final int completed;
  final double completionRate;
  final int totalEarnableXp;
  final int earnedXp;

  const QuestDailySummary({
    required this.total,
    required this.completed,
    required this.completionRate,
    required this.totalEarnableXp,
    required this.earnedXp,
  });
}
