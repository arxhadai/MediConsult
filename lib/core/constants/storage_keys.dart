/// Storage keys for persistent data
class StorageKeys {
  // Authentication
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  
  // User Preferences
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';
  static const String notificationsEnabled = 'notifications_enabled';
  
  // Video Call Settings
  static const String audioEnabled = 'audio_enabled';
  static const String videoEnabled = 'video_enabled';
  static const String lastUsedCamera = 'last_used_camera';
  
  // App State
  static const String onboardingCompleted = 'onboarding_completed';
  static const String lastSyncTime = 'last_sync_time';
}