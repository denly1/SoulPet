import 'package:soulpet/core/constants/app_constants.dart';
import 'package:soulpet/core/storage/secure_storage.dart';


class AuthLocalDatasource {
  final SecureStorage _secureStorage;
  const AuthLocalDatasource(this._secureStorage);

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
}
