import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  LocaleController({Locale locale = const Locale('en')}) : _locale = locale;

  Locale _locale;

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) {
      return;
    }
    _locale = locale;
    notifyListeners();
  }

  void selectEnglish() {
    setLocale(const Locale('en'));
  }

  void selectTurkish() {
    setLocale(const Locale('tr'));
  }
}
