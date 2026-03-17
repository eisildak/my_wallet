import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleViewModel extends ChangeNotifier {
  static const String _languageKey = 'language_code';
  // Öğrenciler İçin Not: Uygulamanın varsayılan (default) açılış dili İngilizce olarak belirlendi.
  Locale _locale = const Locale('en'); 
  bool _isLoading = true;

  Locale get locale => _locale;
  bool get isLoading => _isLoading;

  LocaleViewModel() {
    // Sınıf oluşur oluşmaz cihaz hafızasındaki (eğer varsa) dil tercihini yükle.
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
    // Sadece desteklenen [en, tr, de] dillerine izin ver. Değilse işlemi kes.
    if (!['en', 'tr', 'de'].contains(locale.languageCode)) return; 
    
    // Uygulama dilini güncelle ve arayüze haber ver (arayüz anında güncellenir).
    _locale = locale;
    notifyListeners();

    // Seçilen dili kalıcı olarak kaydet ki kullanıcı uygulamayı kapatıp açtığında aynı dil gelsin.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }
}
