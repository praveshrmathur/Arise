/// Project Hunter XP & Level Progression Engine
/// Formula specified in product requirements:
/// XP required for next level = 100 + (50 * currentLevel)
class LevelCalculator {
  LevelCalculator._();

  /// Calculates XP needed to advance from [level] to [level + 1]
  static int xpRequiredForLevel(int level) {
    if (level < 1) return 150;
    return 100 + (50 * level);
  }

  /// Calculates cumulative total XP required to reach [targetLevel] from Level 1
  static int cumulativeXpForLevel(int targetLevel) {
    if (targetLevel <= 1) return 0;
    int total = 0;
    for (int l = 1; l < targetLevel; l++) {
      total += xpRequiredForLevel(l);
    }
    return total;
  }

  /// Computes the player's level given [totalXp]
  static int calculateLevel(int totalXp) {
    if (totalXp <= 0) return 1;

    int currentLevel = 1;
    int remainingXp = totalXp;

    while (true) {
      final needed = xpRequiredForLevel(currentLevel);
      if (remainingXp >= needed) {
        remainingXp -= needed;
        currentLevel++;
      } else {
        break;
      }
    }

    return currentLevel;
  }

  /// Returns current progress in current level: {currentLevelXp, neededLevelXp, progressPercent}
  static LevelProgress calculateProgress(int totalXp) {
    if (totalXp <= 0) {
      return const LevelProgress(
        currentLevel: 1,
        currentLevelXp: 0,
        xpForNextLevel: 150,
        progressPercent: 0.0,
      );
    }

    final level = calculateLevel(totalXp);
    final previousLevelTotalXp = cumulativeXpForLevel(level);
    final currentLevelXp = totalXp - previousLevelTotalXp;
    final xpForNextLevel = xpRequiredForLevel(level);
    final progress = (currentLevelXp / xpForNextLevel).clamp(0.0, 1.0);

    return LevelProgress(
      currentLevel: level,
      currentLevelXp: currentLevelXp,
      xpForNextLevel: xpForNextLevel,
      progressPercent: progress,
    );
  }
}

class LevelProgress {
  final int currentLevel;
  final int currentLevelXp;
  final int xpForNextLevel;
  final double progressPercent;

  const LevelProgress({
    required this.currentLevel,
    required this.currentLevelXp,
    required this.xpForNextLevel,
    required this.progressPercent,
  });
}
