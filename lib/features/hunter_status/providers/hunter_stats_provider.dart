import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/rank_constants.dart';
import '../../../core/utils/level_calculator.dart';
import '../../../shared/models/xp_transaction_model.dart';
import '../models/hunter_stats_model.dart';

class HunterStatsNotifier extends StateNotifier<HunterStatsModel> {
  final List<XpTransactionModel> _history = [];

  HunterStatsNotifier()
      : super(HunterStatsModel.demo('hunter-demo-uuid-001'));

  List<XpTransactionModel> get xpHistory => List.unmodifiable(_history);

  /// Awards XP and increases relevant character attributes
  void awardXp({
    required int amount,
    required String reason,
    required String category, // 'strength', 'cardio', 'walking', 'mobility', 'recovery', 'consistency'
  }) {
    if (amount <= 0) return;

    final newTotalXp = state.totalXp + amount;
    final newLevel = LevelCalculator.calculateLevel(newTotalXp);
    final newRank = HunterRank.fromLevel(newLevel);

    // Attribute allocation based on activity type
    int strDelta = 0;
    int agiDelta = 0;
    int vitDelta = 0;
    int endDelta = 0;
    int disDelta = 1; // Any completed quest improves discipline

    switch (category.toLowerCase()) {
      case 'strength':
        strDelta = 2;
        break;
      case 'cardio':
        endDelta = 2;
        break;
      case 'walking':
        agiDelta = 1;
        endDelta = 1;
        break;
      case 'mobility':
        agiDelta = 1;
        vitDelta = 1;
        break;
      case 'recovery':
      case 'hydration':
        vitDelta = 2;
        break;
      case 'consistency':
        disDelta = 3;
        break;
    }

    _history.insert(
      0,
      XpTransactionModel(
        id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
        userId: state.userId,
        amount: amount,
        reason: reason,
        sourceCategory: category,
        createdAt: DateTime.now(),
      ),
    );

    state = state.copyWith(
      totalXp: newTotalXp,
      level: newLevel,
      rank: newRank,
      strength: state.strength + strDelta,
      agility: state.agility + agiDelta,
      vitality: state.vitality + vitDelta,
      endurance: state.endurance + endDelta,
      discipline: state.discipline + disDelta,
      totalQuestsCompleted: state.totalQuestsCompleted + 1,
      updatedAt: DateTime.now(),
    );
  }

  void incrementWorkoutCount() {
    state = state.copyWith(
      totalWorkoutsCompleted: state.totalWorkoutsCompleted + 1,
      updatedAt: DateTime.now(),
    );
  }
}

final hunterStatsProvider =
    StateNotifierProvider<HunterStatsNotifier, HunterStatsModel>((ref) {
  return HunterStatsNotifier();
});
