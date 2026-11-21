import '../../../core/constants/rank_constants.dart';
import '../../../core/utils/level_calculator.dart';

class HunterStatsModel {
  final String userId;
  final int level;
  final HunterRank rank;
  final int totalXp;
  final int strength; // STR: Weight & resistance training
  final int agility; // AGI: Movement, speed, walking
  final int vitality; // VIT: Recovery, sleep, hydration
  final int endurance; // END: Cardio, running, stamina
  final int discipline; // DIS: Habit streaks, daily completions
  final int currentStreak;
  final int totalQuestsCompleted;
  final int totalWorkoutsCompleted;
  final DateTime updatedAt;

  const HunterStatsModel({
    required this.userId,
    required this.level,
    required this.rank,
    required this.totalXp,
    required this.strength,
    required this.agility,
    required this.vitality,
    required this.endurance,
    required this.discipline,
    this.currentStreak = 3,
    this.totalQuestsCompleted = 12,
    this.totalWorkoutsCompleted = 8,
    required this.updatedAt,
  });

  LevelProgress get progress => LevelCalculator.calculateProgress(totalXp);

  factory HunterStatsModel.initial(String userId) {
    return HunterStatsModel(
      userId: userId,
      level: 1,
      rank: HunterRank.e,
      totalXp: 0,
      strength: 10,
      agility: 10,
      vitality: 10,
      endurance: 10,
      discipline: 10,
      currentStreak: 0,
      totalQuestsCompleted: 0,
      totalWorkoutsCompleted: 0,
      updatedAt: DateTime.now(),
    );
  }

  factory HunterStatsModel.demo(String userId) {
    return HunterStatsModel(
      userId: userId,
      level: 7,
      rank: HunterRank.e,
      totalXp: 1850,
      strength: 28,
      agility: 22,
      vitality: 19,
      endurance: 24,
      discipline: 31,
      currentStreak: 5,
      totalQuestsCompleted: 18,
      totalWorkoutsCompleted: 12,
      updatedAt: DateTime.now(),
    );
  }

  HunterStatsModel copyWith({
    int? level,
    HunterRank? rank,
    int? totalXp,
    int? strength,
    int? agility,
    int? vitality,
    int? endurance,
    int? discipline,
    int? currentStreak,
    int? totalQuestsCompleted,
    int? totalWorkoutsCompleted,
    DateTime? updatedAt,
  }) {
    return HunterStatsModel(
      userId: userId,
      level: level ?? this.level,
      rank: rank ?? this.rank,
      totalXp: totalXp ?? this.totalXp,
      strength: strength ?? this.strength,
      agility: agility ?? this.agility,
      vitality: vitality ?? this.vitality,
      endurance: endurance ?? this.endurance,
      discipline: discipline ?? this.discipline,
      currentStreak: currentStreak ?? this.currentStreak,
      totalQuestsCompleted: totalQuestsCompleted ?? this.totalQuestsCompleted,
      totalWorkoutsCompleted: totalWorkoutsCompleted ?? this.totalWorkoutsCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'level': level,
      'rank': rank.code,
      'total_xp': totalXp,
      'strength': strength,
      'agility': agility,
      'vitality': vitality,
      'endurance': endurance,
      'discipline': discipline,
      'current_streak': currentStreak,
      'total_quests_completed': totalQuestsCompleted,
      'total_workouts_completed': totalWorkoutsCompleted,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory HunterStatsModel.fromJson(Map<String, dynamic> json) {
    final lvl = json['level'] as int? ?? 1;
    final totalXp = json['total_xp'] as int? ?? 0;
    return HunterStatsModel(
      userId: json['user_id'] as String,
      level: lvl,
      rank: HunterRank.fromLevel(lvl),
      totalXp: totalXp,
      strength: json['strength'] as int? ?? 10,
      agility: json['agility'] as int? ?? 10,
      vitality: json['vitality'] as int? ?? 10,
      endurance: json['endurance'] as int? ?? 10,
      discipline: json['discipline'] as int? ?? 10,
      currentStreak: json['current_streak'] as int? ?? 0,
      totalQuestsCompleted: json['total_quests_completed'] as int? ?? 0,
      totalWorkoutsCompleted: json['total_workouts_completed'] as int? ?? 0,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
