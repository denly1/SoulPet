/// Gender of the *user* (not the pet). Used both for profile storage and to
/// drive gendered verb endings in copy across the app (e.g. "ты выбрал" vs
/// "ты выбрала").
enum UserGender { male, female, unspecified }

extension UserGenderX on UserGender {
  String get code {
    switch (this) {
      case UserGender.male:
        return 'male';
      case UserGender.female:
        return 'female';
      case UserGender.unspecified:
        return 'unspecified';
    }
  }

  static UserGender fromCode(String? code) {
    switch (code) {
      case 'male':
        return UserGender.male;
      case 'female':
        return UserGender.female;
      default:
        return UserGender.unspecified;
    }
  }
}

/// Profile data the user fills in immediately after creating an account or
/// signing in for the first time.
class UserProfile {
  final UserGender gender;
  final int age;
  final String nickname;

  const UserProfile({
    required this.gender,
    required this.age,
    required this.nickname,
  });
}
