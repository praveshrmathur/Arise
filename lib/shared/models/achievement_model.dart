class AchievementModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final String iconName;
  final int xpReward;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0

  const AchievementModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.iconName,
    required this.xpReward,
    this.isUnlocked = false,
    this.unlockedAt,
    this.progress = 0.0,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconName: json['icon_name'] as String? ?? 'trophy',
      xpReward: json['xp_reward'] as int? ?? 50,
      isUnlocked: json['is_unlocked'] as bool? ?? false,
      unlockedAt: json['unlocked_at'] != null ? DateTime.parse(json['unlocked_at'] as String) : null,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'icon_name': iconName,
      'xp_reward': xpReward,
      'is_unlocked': isUnlocked,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'progress': progress,
    };
  }
}
