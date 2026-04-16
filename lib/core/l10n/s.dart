import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/l10n/strings_en.dart';
import 'package:soulpet/core/l10n/strings_ru.dart';

/// Usage: S.of(context).login  OR  S.current.login
class S {
  S._();

  static bool get _isRu => LocaleProvider.instance.isRu;

  static String get appName => _isRu ? StringsRu.appName : StringsEn.appName;
  static String get next => _isRu ? StringsRu.next : StringsEn.next;
  static String get back => _isRu ? StringsRu.back : StringsEn.back;
  static String get confirm => _isRu ? StringsRu.confirm : StringsEn.confirm;
  static String get cancel => _isRu ? StringsRu.cancel : StringsEn.cancel;
  static String get save => _isRu ? StringsRu.save : StringsEn.save;
  static String get retry => _isRu ? StringsRu.retry : StringsEn.retry;
  static String get loading => _isRu ? StringsRu.loading : StringsEn.loading;
  static String get error => _isRu ? StringsRu.error : StringsEn.error;
  static String get success => _isRu ? StringsRu.success : StringsEn.success;
  static String get skip => _isRu ? StringsRu.skip : StringsEn.skip;

  static String get onboardingTitle1 => _isRu ? StringsRu.onboardingTitle1 : StringsEn.onboardingTitle1;
  static String get onboardingDesc1 => _isRu ? StringsRu.onboardingDesc1 : StringsEn.onboardingDesc1;
  static String get onboardingTitle2 => _isRu ? StringsRu.onboardingTitle2 : StringsEn.onboardingTitle2;
  static String get onboardingDesc2 => _isRu ? StringsRu.onboardingDesc2 : StringsEn.onboardingDesc2;
  static String get onboardingTitle3 => _isRu ? StringsRu.onboardingTitle3 : StringsEn.onboardingTitle3;
  static String get onboardingDesc3 => _isRu ? StringsRu.onboardingDesc3 : StringsEn.onboardingDesc3;
  static String get getStarted => _isRu ? StringsRu.getStarted : StringsEn.getStarted;

  static String get login => _isRu ? StringsRu.login : StringsEn.login;
  static String get register => _isRu ? StringsRu.register : StringsEn.register;
  static String get email => _isRu ? StringsRu.email : StringsEn.email;
  static String get password => _isRu ? StringsRu.password : StringsEn.password;
  static String get confirmPassword => _isRu ? StringsRu.confirmPassword : StringsEn.confirmPassword;
  static String get username => _isRu ? StringsRu.username : StringsEn.username;
  static String get forgotPassword => _isRu ? StringsRu.forgotPassword : StringsEn.forgotPassword;
  static String get noAccount => _isRu ? StringsRu.noAccount : StringsEn.noAccount;
  static String get haveAccount => _isRu ? StringsRu.haveAccount : StringsEn.haveAccount;
  static String get signInWithGoogle => _isRu ? StringsRu.signInWithGoogle : StringsEn.signInWithGoogle;
  static String get signInWithApple => _isRu ? StringsRu.signInWithApple : StringsEn.signInWithApple;
  static String get orContinueWith => _isRu ? StringsRu.orContinueWith : StringsEn.orContinueWith;
  static String get resetPassword => _isRu ? StringsRu.resetPassword : StringsEn.resetPassword;
  static String get resetPasswordDesc => _isRu ? StringsRu.resetPasswordDesc : StringsEn.resetPasswordDesc;
  static String get sendResetLink => _isRu ? StringsRu.sendResetLink : StringsEn.sendResetLink;
  static String get resetEmailSent => _isRu ? StringsRu.resetEmailSent : StringsEn.resetEmailSent;

  static String get feed => _isRu ? StringsRu.feed : StringsEn.feed;
  static String get pet => _isRu ? StringsRu.pet : StringsEn.pet;
  static String get play => _isRu ? StringsRu.play : StringsEn.play;
  static String get chat => _isRu ? StringsRu.chat : StringsEn.chat;
  static String get games => _isRu ? StringsRu.games : StringsEn.games;
  static String get buddy => _isRu ? StringsRu.buddy : StringsEn.buddy;
  static String get food => _isRu ? StringsRu.food : StringsEn.food;
  static String get petHome => _isRu ? StringsRu.petHome : StringsEn.petHome;
  static String get chatHint => _isRu ? StringsRu.chatHint : StringsEn.chatHint;

  static String get profile => _isRu ? StringsRu.profile : StringsEn.profile;
  static String get shop => _isRu ? StringsRu.shop : StringsEn.shop;
  static String get inventory => _isRu ? StringsRu.inventory : StringsEn.inventory;

  static String get networkError => _isRu ? StringsRu.networkError : StringsEn.networkError;
  static String get serverError => _isRu ? StringsRu.serverError : StringsEn.serverError;
  static String get unknownError => _isRu ? StringsRu.unknownError : StringsEn.unknownError;
  static String get invalidEmail => _isRu ? StringsRu.invalidEmail : StringsEn.invalidEmail;
  static String get weakPassword => _isRu ? StringsRu.weakPassword : StringsEn.weakPassword;
  static String get passwordMismatch => _isRu ? StringsRu.passwordMismatch : StringsEn.passwordMismatch;
  static String get fieldRequired => _isRu ? StringsRu.fieldRequired : StringsEn.fieldRequired;
  static String get nameTooShort => _isRu ? StringsRu.nameTooShort : StringsEn.nameTooShort;
}
