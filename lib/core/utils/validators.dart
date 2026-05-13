import 'package:soulpet/core/constants/app_constants.dart';
import 'package:soulpet/core/l10n/s.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';

class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.fieldRequired;
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return S.invalidEmail;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return S.fieldRequired;
    }
    if (value.length < AppConstants.minPasswordLength) {
      return S.weakPassword;
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return S.fieldRequired;
    }
    if (value != password) {
      return S.passwordMismatch;
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.fieldRequired;
    }
    if (value.trim().length < 2) {
      return S.nameTooShort;
    }
    return null;
  }

  static String? petName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.fieldRequired;
    }
    if (value.trim().length < AppConstants.minPetNameLength) {
      return S.nameTooShort;
    }
    if (value.trim().length > AppConstants.maxPetNameLength) {
      final isRu = LocaleProvider.instance.isRu;
      final max = AppConstants.maxPetNameLength;
      return isRu
          ? 'Имя слишком длинное (макс. $max символов)'
          : 'Name is too long (max. $max characters)';
    }
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.fieldRequired;
    }
    return null;
  }
}
