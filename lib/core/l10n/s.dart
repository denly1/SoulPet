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
  static String get or => _isRu ? StringsRu.or : StringsEn.or;
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

  // ── User profile setup ──
  static String get userProfileTitle => _isRu ? StringsRu.userProfileTitle : StringsEn.userProfileTitle;
  static String get userProfileSubtitle => _isRu ? StringsRu.userProfileSubtitle : StringsEn.userProfileSubtitle;
  static String get userProfileNicknameLabel => _isRu ? StringsRu.userProfileNicknameLabel : StringsEn.userProfileNicknameLabel;
  static String get userProfileNicknameHint => _isRu ? StringsRu.userProfileNicknameHint : StringsEn.userProfileNicknameHint;
  static String get userProfileGenderLabel => _isRu ? StringsRu.userProfileGenderLabel : StringsEn.userProfileGenderLabel;
  static String get userProfileMale => _isRu ? StringsRu.userProfileMale : StringsEn.userProfileMale;
  static String get userProfileFemale => _isRu ? StringsRu.userProfileFemale : StringsEn.userProfileFemale;
  static String get userProfileUnspecified => _isRu ? StringsRu.userProfileUnspecified : StringsEn.userProfileUnspecified;
  static String get userProfileGenderRequired => _isRu ? StringsRu.userProfileGenderRequired : StringsEn.userProfileGenderRequired;
  static String get userProfileAgeLabel => _isRu ? StringsRu.userProfileAgeLabel : StringsEn.userProfileAgeLabel;
  static String get userProfileAgeHint => _isRu ? StringsRu.userProfileAgeHint : StringsEn.userProfileAgeHint;
  static String get userProfileBirthDateConfirm => _isRu ? StringsRu.userProfileBirthDateConfirm : StringsEn.userProfileBirthDateConfirm;
  static String get userProfileBirthDateCancel => _isRu ? StringsRu.userProfileBirthDateCancel : StringsEn.userProfileBirthDateCancel;
  static String get userProfileContinue => _isRu ? StringsRu.userProfileContinue : StringsEn.userProfileContinue;
  static String get userProfileStepLabel => _isRu ? StringsRu.userProfileStepLabel : StringsEn.userProfileStepLabel;
  static String get userProfileGreetingPrefix => _isRu ? StringsRu.userProfileGreetingPrefix : StringsEn.userProfileGreetingPrefix;
  static String get nicknameTooShort => _isRu ? StringsRu.nicknameTooShort : StringsEn.nicknameTooShort;
  static String get nicknameTooLong => _isRu ? StringsRu.nicknameTooLong : StringsEn.nicknameTooLong;
  static String get ageInvalid => _isRu ? StringsRu.ageInvalid : StringsEn.ageInvalid;

  // ── Pet test — intro ──
  static String get petTestIntroTitle => _isRu ? StringsRu.petTestIntroTitle : StringsEn.petTestIntroTitle;
  static String get petTestIntroSubtitle => _isRu ? StringsRu.petTestIntroSubtitle : StringsEn.petTestIntroSubtitle;
  static String get petTestStart => _isRu ? StringsRu.petTestStart : StringsEn.petTestStart;
  static String get petTestSkipBtn => _isRu ? StringsRu.petTestSkipBtn : StringsEn.petTestSkipBtn;

  // ── Pet test — flow ──
  static String get petTestNext => _isRu ? StringsRu.petTestNext : StringsEn.petTestNext;
  static String get petTestFinish => _isRu ? StringsRu.petTestFinish : StringsEn.petTestFinish;
  static String get petTestBack => _isRu ? StringsRu.petTestBack : StringsEn.petTestBack;

  // ── Pet test — result ──
  static String get petResultEyebrow => _isRu ? StringsRu.petResultEyebrow : StringsEn.petResultEyebrow;
  static String get petResultCatTitle => _isRu ? StringsRu.petResultCatTitle : StringsEn.petResultCatTitle;
  static String get petResultDogTitle => _isRu ? StringsRu.petResultDogTitle : StringsEn.petResultDogTitle;
  static String get petResultTieTitle => _isRu ? StringsRu.petResultTieTitle : StringsEn.petResultTieTitle;
  static String get petResultSubtitle => _isRu ? StringsRu.petResultSubtitle : StringsEn.petResultSubtitle;
  static String get petResultTieSubtitle => _isRu ? StringsRu.petResultTieSubtitle : StringsEn.petResultTieSubtitle;
  static String get petResultPickName => _isRu ? StringsRu.petResultPickName : StringsEn.petResultPickName;
  static String get petResultPickCat => _isRu ? StringsRu.petResultPickCat : StringsEn.petResultPickCat;
  static String get petResultPickDog => _isRu ? StringsRu.petResultPickDog : StringsEn.petResultPickDog;
  static String get petResultRetake => _isRu ? StringsRu.petResultRetake : StringsEn.petResultRetake;

  // ── Pet manual pick ──
  static String get petManualTitle => _isRu ? StringsRu.petManualTitle : StringsEn.petManualTitle;
  static String get petManualSubtitle => _isRu ? StringsRu.petManualSubtitle : StringsEn.petManualSubtitle;
  static String get petManualKitten => _isRu ? StringsRu.petManualKitten : StringsEn.petManualKitten;
  static String get petManualKittenDesc => _isRu ? StringsRu.petManualKittenDesc : StringsEn.petManualKittenDesc;
  static String get petManualPuppy => _isRu ? StringsRu.petManualPuppy : StringsEn.petManualPuppy;
  static String get petManualPuppyDesc => _isRu ? StringsRu.petManualPuppyDesc : StringsEn.petManualPuppyDesc;
  static String get petManualHint => _isRu ? StringsRu.petManualHint : StringsEn.petManualHint;

  // ── Pet setup ──
  static String get petSetupTitle => _isRu ? StringsRu.petSetupTitle : StringsEn.petSetupTitle;
  static String get petSetupSubtitle => _isRu ? StringsRu.petSetupSubtitle : StringsEn.petSetupSubtitle;
  static String get petSetupNameLabel => _isRu ? StringsRu.petSetupNameLabel : StringsEn.petSetupNameLabel;
  static String get petSetupNameHint => _isRu ? StringsRu.petSetupNameHint : StringsEn.petSetupNameHint;
  static String get petSetupNameExample => _isRu ? StringsRu.petSetupNameExample : StringsEn.petSetupNameExample;
  static String get petSetupGenderLabel => _isRu ? StringsRu.petSetupGenderLabel : StringsEn.petSetupGenderLabel;
  static String get petSetupBoy => _isRu ? StringsRu.petSetupBoy : StringsEn.petSetupBoy;
  static String get petSetupGirl => _isRu ? StringsRu.petSetupGirl : StringsEn.petSetupGirl;
  static String get petSetupContinue => _isRu ? StringsRu.petSetupContinue : StringsEn.petSetupContinue;
  static String get petSetupStepLabel => _isRu ? StringsRu.petSetupStepLabel : StringsEn.petSetupStepLabel;
  static String get petNameRequired => _isRu ? StringsRu.petNameRequired : StringsEn.petNameRequired;
  static String get petNameTooShort => _isRu ? StringsRu.petNameTooShort : StringsEn.petNameTooShort;
  static String get petNameTooLong => _isRu ? StringsRu.petNameTooLong : StringsEn.petNameTooLong;

  // ── House selection ──
  static String get houseTitle => _isRu ? StringsRu.houseTitle : StringsEn.houseTitle;
  static String get houseTitleFor => _isRu ? StringsRu.houseTitleFor : StringsEn.houseTitleFor;
  static String get houseSubtitlePrefixMale => _isRu ? StringsRu.houseSubtitlePrefixMale : StringsEn.houseSubtitlePrefixMale;
  static String get houseSubtitlePrefixFemale => _isRu ? StringsRu.houseSubtitlePrefixFemale : StringsEn.houseSubtitlePrefixFemale;
  static String get houseSubtitleSuffix => _isRu ? StringsRu.houseSubtitleSuffix : StringsEn.houseSubtitleSuffix;
  static String get houseSubtitleFallback => _isRu ? StringsRu.houseSubtitleFallback : StringsEn.houseSubtitleFallback;
  static String get houseApartmentTitle => _isRu ? StringsRu.houseApartmentTitle : StringsEn.houseApartmentTitle;
  static String get houseApartmentDesc => _isRu ? StringsRu.houseApartmentDesc : StringsEn.houseApartmentDesc;
  static String get houseHouseTitle => _isRu ? StringsRu.houseHouseTitle : StringsEn.houseHouseTitle;
  static String get houseHouseDesc => _isRu ? StringsRu.houseHouseDesc : StringsEn.houseHouseDesc;
  static String get houseDone => _isRu ? StringsRu.houseDone : StringsEn.houseDone;
}
