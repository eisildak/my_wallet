import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleViewModel extends ChangeNotifier {
  static const String _languageKey = 'language_code';
  Locale _locale = const Locale('en'); // Varsayılan dil İngilizce
  bool _isLoading = true;

  Locale get locale => _locale;
  bool get isLoading => _isLoading;

  LocaleViewModel() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(_languageKey);

    if (savedLang != null) {
      _locale = Locale(savedLang);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!['en', 'tr', 'de'].contains(locale.languageCode)) return; // Sadece desteklenen dillere izin ver
    
    _locale = locale;
    notifyListeners();

    // Seçilen dili kalıcı olarak kaydet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }
}
