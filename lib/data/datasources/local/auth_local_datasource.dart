import 'package:soulpet/core/constants/app_constants.dart';
import 'package:soulpet/core/storage/secure_storage.dart';
import 'package:soulpet/domain/entities/user_profile_entity.dart';


class AuthLocalDatasource {
  final SecureStorage _secureStorage;
  const AuthLocalDatasource(this._secureStorage);

  SecureStorage get secureStorage => _secureStorage;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    await _secureStorage.saveAccessToken(accessToken);
    await _secureStorage.saveRefreshToken(refreshToken);
    await _secureStorage.saveUserId(userId);
  }

  Future<void> clearTokens() async {
    await _secureStorage.clearAll();
  }

  Future<bool> hasValidSession() async {
    return _secureStorage.hasAccessToken();
  }

  Future<String?> getAccessToken() => _secureStorage.getAccessToken();
  Future<String?> getRefreshToken() => _secureStorage.getRefreshToken();
  Future<String?> getUserId() => _secureStorage.getUserId();

  Future<void> markOnboardingDone() async {
    await _secureStorage.write(AppConstants.keyOnboardingDone, 'true');
  }

  Future<bool> isOnboardingDone() async {
    final val = await _secureStorage.read(AppConstants.keyOnboardingDone);
    return val == 'true';
  }

  Future<void> markPetTestDone() async {
    await _secureStorage.write(AppConstants.keyPetTestDone, 'true');
  }

  Future<bool> isPetTestDone() async {
    final val = await _secureStorage.read(AppConstants.keyPetTestDone);
    return val == 'true';
  }

  // ── User profile ─────────────────────────────────────────────────────────

  Future<void> saveUserProfile(UserProfile profile) async {
    await _secureStorage.write(
      AppConstants.keyUserGender,
      profile.gender.code,
    );
    await _secureStorage.write(
      AppConstants.keyUserAge,
      profile.age.toString(),
    );
    await _secureStorage.write(
      AppConstants.keyUserNickname,
      profile.nickname,
    );
    await _secureStorage.write(AppConstants.keyUserProfileDone, 'true');
  }

  Future<UserProfile?> getUserProfile() async {
    final genderRaw = await _secureStorage.read(AppConstants.keyUserGender);
    final ageRaw = await _secureStorage.read(AppConstants.keyUserAge);
    final nickname = await _secureStorage.read(AppConstants.keyUserNickname);
    if (genderRaw == null && ageRaw == null && nickname == null) return null;
    return UserProfile(
      gender: UserGenderX.fromCode(genderRaw),
      age: int.tryParse(ageRaw ?? '') ?? 0,
      nickname: nickname ?? '',
    );
  }

  Future<bool> isUserProfileDone() async {
    final val = await _secureStorage.read(AppConstants.keyUserProfileDone);
    return val == 'true';
  }

  Future<void> clearUserProfile() async {
    await _secureStorage.delete(AppConstants.keyUserGender);
    await _secureStorage.delete(AppConstants.keyUserAge);
    await _secureStorage.delete(AppConstants.keyUserNickname);
    await _secureStorage.delete(AppConstants.keyUserProfileDone);
  }
}
