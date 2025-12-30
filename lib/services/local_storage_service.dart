/// Yerel veri saklama servisi (Firebase yerine)
/// lib/services/local_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_balance_model.dart';

class LocalStorageService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';
  static const String _balancesKey = 'balances';

  /// Kullanıcı kayıt işlemi
  Future<Map<String, dynamic>?> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Mevcut kullanıcıları al
      final usersJson = prefs.getString(_usersKey) ?? '{}';
      final Map<String, dynamic> users = jsonDecode(usersJson);
      
      // E-posta kontrolü
      if (users.containsKey(email)) {
        throw Exception('Bu e-posta zaten kullanılıyor.');
      }
      
      // Yeni kullanıcı ekle
      final userId = DateTime.now().millisecondsSinceEpoch.toString();
      users[email] = {
        'uid': userId,
        'email': email,
        'password': password, // Gerçek uygulamada şifrelenmeli!
        'username': username,
      };
      
      // Kaydet
      await prefs.setString(_usersKey, jsonEncode(users));
      
      return users[email];
    } catch (e) {
      throw Exception('Kayıt hatası: $e');
    }
  }

  /// Kullanıcı giriş işlemi
  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Kullanıcıları al
      final usersJson = prefs.getString(_usersKey) ?? '{}';
      final Map<String, dynamic> users = jsonDecode(usersJson);
      
      // Kullanıcı kontrolü
      if (!users.containsKey(email)) {
        throw Exception('Kullanıcı bulunamadı.');
      }
      
      final user = users[email];
      if (user['password'] != password) {
        throw Exception('Hatalı şifre.');
      }
      
      // Oturumu kaydet
      await prefs.setString(_currentUserKey, jsonEncode(user));
      
      return user;
    } catch (e) {
      throw Exception('Giriş hatası: $e');
    }
  }

  /// Kullanıcı çıkış işlemi
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  /// Anlık kullanıcı durumu
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    return jsonDecode(userJson);
  }

  /// Kullanıcı bakiyesini kaydet
  Future<void> saveBalance(UserBalanceModel balance) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Tüm bakiyeleri al
      final balancesJson = prefs.getString(_balancesKey) ?? '{}';
      final Map<String, dynamic> balances = jsonDecode(balancesJson);
      
      // Güncelle
      balances[balance.userId] = balance.toFirestore();
      
      // Kaydet
      await prefs.setString(_balancesKey, jsonEncode(balances));
    } catch (e) {
      throw Exception('Bakiye kaydedilemedi: $e');
    }
  }

  /// Kullanıcı bakiyesini oku
  Future<UserBalanceModel?> getBalance(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final balancesJson = prefs.getString(_balancesKey) ?? '{}';
      final Map<String, dynamic> balances = jsonDecode(balancesJson);
      
      if (balances.containsKey(userId)) {
        return UserBalanceModel.fromFirestore(
          Map<String, dynamic>.from(balances[userId]),
          userId,
        );
      }
      
      return UserBalanceModel.empty(userId);
    } catch (e) {
      throw Exception('Bakiye okunamadı: $e');
    }
  }

  /// İlk kayıtta boş bakiye oluştur
  Future<void> createInitialBalance(String userId) async {
    final initialBalance = UserBalanceModel.empty(userId);
    await saveBalance(initialBalance);
  }
}
