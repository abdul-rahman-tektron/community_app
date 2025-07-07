
import 'package:community_app/core/base/base_notifier.dart';
import 'package:flutter/material.dart';

class LanguageNotifier extends BaseChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void switchLanguage() {
    _locale = _locale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    notifyListeners();
  }
}
