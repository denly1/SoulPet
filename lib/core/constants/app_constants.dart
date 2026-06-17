class AppConstants {
  AppConstants._();

  static const String appName = 'SoulPet';
  static const String appVersion = '0.1.0';

  // Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyPetTestDone = 'pet_test_done';
  static const String keySelectedHouseId = 'selected_house_id';

  // Local auth credentials (stub mode — no real API yet)
  static const String keyRegisteredEmail = 'registered_email';
  static const String keyRegisteredPassword = 'registered_password';
  static const String keyRegisteredUsername = 'registered_username';
  static const String keyRegisteredUserId = 'registered_user_id';

  // User profile (collected after registration / first login)
  static const String keyUserProfileDone = 'user_profile_done';
  static const String keyUserGender = 'user_gender';
  static const String keyUserAge = 'user_age';
  static const String keyUserNickname = 'user_nickname';

  // Profile bounds
  static const int minNicknameLength = 2;
  static const int maxNicknameLength = 24;
  static const int minUserAge = 8;
  static const int maxUserAge = 120;

  // API
  static const String baseUrl = 'https://api.soulpet.app/v1';
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  // Pet
  static const int maxPetNameLength = 20;
  static const int minPetNameLength = 2;

  // Auth
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 64;

  // Game
  static const int dailyLoginCoins = 50;
  static const int petInteractionCoins = 10;
  static const int minigameRewardCoins = 30;

  // Pet action interval in seconds
  static const int petActionIntervalMin = 8;
  static const int petActionIntervalMax = 20;
}
