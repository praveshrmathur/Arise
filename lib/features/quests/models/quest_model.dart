enum QuestCategory {
  strength,
  cardio,
  walking,
  mobility,
  recovery,
  hydration,
  consistency,
  discipline,
}

enum QuestDifficulty {
  beginner,
  intermediate,
  advanced,
  expert,
}

enum VerificationMethod {
  manual,
  healthConnect,
  appleHealth,
}

enum QuestStatus {
  pending,
  completed,
  skipped,
}

class QuestModel {
  final String id;
  final String title;
  final String description;
  final QuestCategory category;
  final QuestDifficulty difficulty;
  final String instructions;
  final String targetMetric;
  final int targetValue;
  final String unit;
  final int durationMinutes;
  final int xpReward;
  final VerificationMethod verificationMethod;
  final DateTime scheduledDate;
  final DateTime? expiresAt;
  final QuestStatus status;
  final DateTime? completedAt;

  const QuestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.instructions,
    required this.targetMetric,
    required this.targetValue,
    required this.unit,
    required this.durationMinutes,
    required this.xpReward,
    required this.verificationMethod,
    required this.scheduledDate,
    this.expiresAt,
    this.status = QuestStatus.pending,
    this.completedAt,
  });

  bool get isCompleted => status == QuestStatus.completed;
  bool get isSkipped => status == QuestStatus.skipped;
  bool get isPending => status == QuestStatus.pending;

  QuestModel copyWith({
    QuestStatus? status,
    DateTime? completedAt,
  }) {
    return QuestModel(
      id: id,
      title: title,
      description: description,
      category: category,
      difficulty: difficulty,
      instructions: instructions,
      targetMetric: targetMetric,
      targetValue: targetValue,
      unit: unit,
      durationMinutes: durationMinutes,
      xpReward: xpReward,
      verificationMethod: verificationMethod,
      scheduledDate: scheduledDate,
      expiresAt: expiresAt,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: QuestCategory.values.firstWhere(
        (c) => c.name.toLowerCase() == (json['category'] as String).toLowerCase(),
        orElse: () => QuestCategory.strength,
      ),
      difficulty: QuestDifficulty.values.firstWhere(
        (d) => d.name.toLowerCase() == (json['difficulty'] as String).toLowerCase(),
        orElse: () => QuestDifficulty.beginner,
      ),
      instructions: json['instructions'] as String? ?? '',
      targetMetric: json['target_metric'] as String? ?? 'reps',
      targetValue: json['target_value'] as int? ?? 10,
      unit: json['unit'] as String? ?? 'reps',
      durationMinutes: json['duration_minutes'] as int? ?? 15,
      xpReward: json['xp_reward'] as int? ?? 40,
      verificationMethod: VerificationMethod.values.firstWhere(
        (v) => v.name.toLowerCase() == (json['verification_method'] as String? ?? 'manual').toLowerCase(),
        orElse: () => VerificationMethod.manual,
      ),
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
      status: QuestStatus.values.firstWhere(
        (s) => s.name.toLowerCase() == (json['status'] as String? ?? 'pending').toLowerCase(),
        orElse: () => QuestStatus.pending,
      ),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'difficulty': difficulty.name,
      'instructions': instructions,
      'target_metric': targetMetric,
      'target_value': targetValue,
      'unit': unit,
      'duration_minutes': durationMinutes,
      'xp_reward': xpReward,
      'verification_method': verificationMethod.name,
      'scheduled_date': scheduledDate.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'status': status.name,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}
