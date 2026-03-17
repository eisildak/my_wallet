import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingViewModel extends ChangeNotifier {
  bool _hasSeenOnboarding = false;
  bool _isLoading = true;

  bool get hasSeenOnboarding => _hasSeenOnboarding;
  bool get isLoading => _isLoading;

  OnboardingViewModel() {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    try {
      // Öğrenciler İçin Not: SharedPreferences (Cihaz Hafızası) örneğini alıyoruz.
      final prefs = await SharedPreferences.getInstance();
      
      // "hasSeenOnboarding" anahtarıyla (key) kayıtlı bir değer var mı diye bakıyoruz.
      // Yoksa (?? false) varsayılan olarak false kabul ediyoruz.
      _hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    } catch (e) {
      debugPrint('Error loading onboarding status: $e');
      _hasSeenOnboarding = false;
    } finally {
      // İşlem bitince yüklenme durumunu (isLoading) kapatıp arayüze haber (notifyListeners) veriyoruz.
      _isLoading = false;
      notifyListeners();
    }
  }

  // Kullanıcı "Hemen Başla" butonuna bastığında çağrılan metod
  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // "hasSeenOnboarding" verisini "true" olarak cihaz hafızasına KALIYORUZ.
      await prefs.setBool('hasSeenOnboarding', true);
      _hasSeenOnboarding = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving onboarding status: $e');
    }
  }
}
