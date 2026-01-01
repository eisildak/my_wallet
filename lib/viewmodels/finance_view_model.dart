/// Finansal verileri (kur ve bakiye) yöneten ViewModel
/// lib/viewmodels/finance_view_model.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../models/currency_model.dart';
import '../models/user_balance_model.dart';

class FinanceViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _storageService = LocalStorageService();

  List<CurrencyModel> _currencies = [];
  UserBalanceModel? _userBalance;
  bool _isLoading = false;
  String? _errorMessage;

  List<CurrencyModel> get currencies => _currencies;
  UserBalanceModel? get userBalance => _userBalance;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Güncel kur verilerini API'den çek
  Future<void> fetchCurrencies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.getCurrencies();
      if (result != null) {
        _currencies = result;
        _errorMessage = null;
      } else {
        _errorMessage = 'Kur verileri yüklenemedi. Lütfen daha sonra tekrar deneyin.';
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Kur verileri yüklenemedi: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Kullanıcı bakiyesini yükle
  Future<void> loadBalance(String userId) async {
    try {
      _userBalance = await _storageService.getBalance(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Bakiye yüklenemedi: $e';
      notifyListeners();
    }
  }

  /// Kullanıcı bakiyesini güncelle
  Future<void> updateBalance({
    required String userId,
    required double usdAmount,
    required double eurAmount,
    required double goldGram,
  }) async {
    try {
      final newBalance = UserBalanceModel(
        userId: userId,
        usdAmount: usdAmount,
        eurAmount: eurAmount,
        goldGram: goldGram,
        lastUpdated: DateTime.now(),
      );

      await _storageService.saveBalance(newBalance);
      _userBalance = newBalance;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Bakiye güncellenemedi: $e';
      notifyListeners();
    }
  }

  /// Toplam varlık değerini TL cinsinden hesapla
  double getTotalValueInTRY() {
    if (_userBalance == null || _currencies.isEmpty) return 0;

    double total = 0;
    
    // Dolar değeri
    final usdCurrency = _currencies.firstWhere(
      (c) => c.code == 'USD',
      orElse: () => CurrencyModel(name: '', code: '', buyPrice: 0, sellPrice: 0),
    );
    total += _userBalance!.usdAmount * usdCurrency.sellPrice;

    // Euro değeri
    final eurCurrency = _currencies.firstWhere(
      (c) => c.code == 'EUR',
      orElse: () => CurrencyModel(name: '', code: '', buyPrice: 0, sellPrice: 0),
    );
    total += _userBalance!.eurAmount * eurCurrency.sellPrice;

    // Altın değeri
    final goldCurrency = _currencies.firstWhere(
      (c) => c.code == 'GOLD',
      orElse: () => CurrencyModel(name: '', code: '', buyPrice: 0, sellPrice: 0),
    );
    total += _userBalance!.goldGram * goldCurrency.sellPrice;

    return total;
  }
}
