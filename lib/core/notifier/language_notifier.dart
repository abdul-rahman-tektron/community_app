import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class LanguageState {
  final Locale locale;
  LanguageState(this.locale);
}

class LanguageNotifier extends StateNotifier<LanguageState> {
  LanguageNotifier() : super(LanguageState(const Locale('en')));

  void switchLanguage() {
    final newLocale = state.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
    state = LanguageState(newLocale);
  }
}

final languageNotifierProvider = StateNotifierProvider<LanguageNotifier, LanguageState>((ref) {
  return LanguageNotifier();
});