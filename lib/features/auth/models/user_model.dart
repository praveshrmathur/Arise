class HunterUserModel {
  final String id;
  final String email;
  final String hunterName;
  final String? avatarUrl;
  final bool hasCompletedOnboarding;
  final String subscriptionTier; // free, premium
  final DateTime createdAt;

  const HunterUserModel({
    required this.id,
    required this.email,
    required this.hunterName,
    this.avatarUrl,
    this.hasCompletedOnboarding = false,
    this.subscriptionTier = 'free',
    required this.createdAt,
  });

  factory HunterUserModel.fromJson(Map<String, dynamic> json) {
    return HunterUserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      hunterName: json['hunter_name'] as String? ?? 'Nameless Hunter',
      avatarUrl: json['avatar_url'] as String?,
      hasCompletedOnboarding: json['has_completed_onboarding'] as bool? ?? false,
      subscriptionTier: json['subscription_tier'] as String? ?? 'free',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'hunter_name': hunterName,
      'avatar_url': avatarUrl,
      'has_completed_onboarding': hasCompletedOnboarding,
      'subscription_tier': subscriptionTier,
      'created_at': createdAt.toIso8601String(),
    };
  }

  HunterUserModel copyWith({
    String? hunterName,
    String? avatarUrl,
    bool? hasCompletedOnboarding,
    String? subscriptionTier,
  }) {
    return HunterUserModel(
      id: id,
      email: email,
      hunterName: hunterName ?? this.hunterName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      createdAt: createdAt,
    );
  }
}
