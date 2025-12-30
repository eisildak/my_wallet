/// Kullanıcı kimlik doğrulama (Authentication) mantığını yöneten ViewModel
/// lib/viewmodels/auth_view_model.dart
import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get currentUser => _currentUser;

  /// Kullanıcı kayıt işlemi
  Future<bool> register({
    required String email,
    required String password,
    required String username,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _storageService.registerUser(
        email: email,
        password: password,
        username: username,
      );
      
      // İlk bakiyeyi oluştur
      if (_currentUser != null) {
        await _storageService.createInitialBalance(_currentUser!['uid']);
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Kullanıcı giriş işlemi
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _storageService.loginUser(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Kullanıcı çıkış işlemi
  Future<void> logout() async {
    await _storageService.logout();
    _currentUser = null;
    notifyListeners();
  }

  /// Hata mesajını temizle
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Oturum kontrolü
  Future<void> checkSession() async {
    _currentUser = await _storageService.getCurrentUser();
    notifyListeners();
  }
}
