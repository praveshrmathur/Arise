class XpTransactionModel {
  final String id;
  final String userId;
  final int amount;
  final String reason;
  final String sourceCategory; // quest, workout, consistency, milestone
  final DateTime createdAt;

  const XpTransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.reason,
    required this.sourceCategory,
    required this.createdAt,
  });

  factory XpTransactionModel.fromJson(Map<String, dynamic> json) {
    return XpTransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: json['amount'] as int,
      reason: json['reason'] as String,
      sourceCategory: json['source_category'] as String? ?? 'quest',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'reason': reason,
      'source_category': sourceCategory,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
