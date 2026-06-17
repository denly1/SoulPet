import 'package:flutter/foundation.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/data/datasources/local/auth_local_datasource.dart';
import 'package:soulpet/domain/entities/user_profile_entity.dart';

/// Globally available, in-memory cache of the current [UserProfile].
///
/// Why a singleton with [ChangeNotifier]?
/// * UI helpers like gendered verb endings (`выбрал` vs `выбрала`) need
///   *synchronous* access to the user gender — hitting [SecureStorage] on
///   every text render would be wasteful.
/// * When the user updates their profile we want every screen subscribed via
///   `addListener` to rebuild automatically.
///
/// Initialization happens once in `main.dart` via [load], after DI is wired.
class UserProfileProvider extends ChangeNotifier {
  static final UserProfileProvider _instance = UserProfileProvider._();
  static UserProfileProvider get instance => _instance;
  UserProfileProvider._();

  UserProfile? _profile;
  UserProfile? get profile => _profile;

  /// Convenient shortcut for the gendered-verb helpers below.
  UserGender get gender => _profile?.gender ?? UserGender.unspecified;

  /// Display name to address the user with. Falls back to an empty string when
  /// the profile has not been filled in yet.
  String get nickname => _profile?.nickname ?? '';

  bool get isLoaded => _profile != null;

  /// Load the cached profile from storage. Safe to call multiple times — only
  /// the first call hits [AuthLocalDatasource], subsequent ones simply return.
  Future<void> load() async {
    final p = await sl<AuthLocalDatasource>().getUserProfile();
    _profile = p;
    notifyListeners();
  }

  /// Save a fresh profile and update the in-memory cache so that gendered copy
  /// reflects it immediately on the next frame.
  Future<void> save(UserProfile profile) async {
    await sl<AuthLocalDatasource>().saveUserProfile(profile);
    _profile = profile;
    notifyListeners();
  }

  Future<void> clear() async {
    await sl<AuthLocalDatasource>().clearUserProfile();
    _profile = null;
    notifyListeners();
  }

  /// Pick the verb form matching the user's gender. Falls back to [neutral]
  /// when the user hasn't specified a gender yet, or to [male] if no neutral
  /// option was provided.
  String pick({required String male, required String female, String? neutral}) {
    switch (gender) {
      case UserGender.male:
        return male;
      case UserGender.female:
        return female;
      case UserGender.unspecified:
        return neutral ?? male;
    }
  }
}
