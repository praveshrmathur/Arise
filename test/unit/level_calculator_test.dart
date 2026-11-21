import 'package:flutter_test/flutter_test.dart';
import 'package:project_hunter/core/utils/level_calculator.dart';

void main() {
  group('LevelCalculator Progression Engine Tests', () {
    test('XP required formula: 100 + (50 * level)', () {
      expect(LevelCalculator.xpRequiredForLevel(1), equals(150));
      expect(LevelCalculator.xpRequiredForLevel(2), equals(200));
      expect(LevelCalculator.xpRequiredForLevel(3), equals(250));
      expect(LevelCalculator.xpRequiredForLevel(10), equals(600));
    });

    test('Cumulative XP calculation', () {
      expect(LevelCalculator.cumulativeXpForLevel(1), equals(0));
      expect(LevelCalculator.cumulativeXpForLevel(2), equals(150));
      expect(LevelCalculator.cumulativeXpForLevel(3), equals(350)); // 150 + 200
      expect(LevelCalculator.cumulativeXpForLevel(4), equals(600)); // 150 + 200 + 250
    });

    test('Calculate level from Total XP', () {
      expect(LevelCalculator.calculateLevel(0), equals(1));
      expect(LevelCalculator.calculateLevel(100), equals(1));
      expect(LevelCalculator.calculateLevel(150), equals(2));
      expect(LevelCalculator.calculateLevel(349), equals(2));
      expect(LevelCalculator.calculateLevel(350), equals(3));
      expect(LevelCalculator.calculateLevel(600), equals(4));
    });

    test('Calculate level progress details', () {
      final p1 = LevelCalculator.calculateProgress(75);
      expect(p1.currentLevel, equals(1));
      expect(p1.currentLevelXp, equals(75));
      expect(p1.xpForNextLevel, equals(150));
      expect(p1.progressPercent, closeTo(0.5, 0.001));

      final p2 = LevelCalculator.calculateProgress(250);
      expect(p2.currentLevel, equals(2));
      expect(p2.currentLevelXp, equals(100)); // 250 - 150
      expect(p2.xpForNextLevel, equals(200));
      expect(p2.progressPercent, closeTo(0.5, 0.001));
    });
  });
}
