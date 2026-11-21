import 'package:flutter_test/flutter_test.dart';
import 'package:project_hunter/features/quests/models/quest_model.dart';

void main() {
  group('QuestModel Unit Tests', () {
    test('Correct default state and flags', () {
      final quest = QuestModel(
        id: 'q-test-1',
        title: 'Morning Push',
        description: '30 push-ups',
        category: QuestCategory.strength,
        difficulty: QuestDifficulty.beginner,
        instructions: 'Push the ground away with force',
        targetMetric: 'reps',
        targetValue: 30,
        unit: 'reps',
        durationMinutes: 10,
        xpReward: 50,
        verificationMethod: VerificationMethod.manual,
        scheduledDate: DateTime(2026, 11, 21),
      );

      expect(quest.isPending, isTrue);
      expect(quest.isCompleted, isFalse);
      expect(quest.isSkipped, isFalse);

      final completedQuest = quest.copyWith(status: QuestStatus.completed);
      expect(completedQuest.isCompleted, isTrue);
      expect(completedQuest.isPending, isFalse);
    });

    test('JSON serialization & deserialization roundtrip', () {
      final quest = QuestModel(
        id: 'q-test-2',
        title: 'Hydration Protocol',
        description: 'Drink 2000 ml water',
        category: QuestCategory.hydration,
        difficulty: QuestDifficulty.beginner,
        instructions: 'Sip throughout the day',
        targetMetric: 'ml',
        targetValue: 2000,
        unit: 'ml',
        durationMinutes: 5,
        xpReward: 30,
        verificationMethod: VerificationMethod.manual,
        scheduledDate: DateTime(2026, 11, 21),
      );

      final json = quest.toJson();
      final revived = QuestModel.fromJson(json);

      expect(revived.id, equals(quest.id));
      expect(revived.title, equals(quest.title));
      expect(revived.category, equals(QuestCategory.hydration));
      expect(revived.xpReward, equals(30));
    });
  });
}
