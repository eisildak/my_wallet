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
      final prefs = await SharedPreferences.getInstance();
      _hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    } catch (e) {
      debugPrint('Error loading onboarding status: $e');
      _hasSeenOnboarding = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);
      _hasSeenOnboarding = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving onboarding status: $e');
    }
  }
}
