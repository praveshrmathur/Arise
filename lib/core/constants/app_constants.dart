/// Project Hunter Global App Constants
class AppConstants {
  AppConstants._();

  static const String appName = 'PROJECT HUNTER';
  static const String appTagline = 'YOUR REAL LIFE. YOUR MISSIONS. YOUR PROGRESSION.';
  static const String appVersion = '1.0.0';

  // Storage keys
  static const String tokenKey = 'hunter_auth_token';
  static const String userKey = 'hunter_current_user';
  static const String onboardingCompletedKey = 'hunter_onboarding_completed';
  static const String offlineQuestsKey = 'hunter_cached_quests';
  static const String offlineStatsKey = 'hunter_cached_stats';
  static const String offlineQueueKey = 'hunter_offline_completions_queue';
}
