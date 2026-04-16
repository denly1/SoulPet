import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  static final LocaleProvider _instance = LocaleProvider._();
  static LocaleProvider get instance => _instance;
  LocaleProvider._();

  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  bool get isRu => _locale.languageCode == 'ru';

  void toggle() {
    _locale = isRu ? const Locale('en') : const Locale('ru');
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
