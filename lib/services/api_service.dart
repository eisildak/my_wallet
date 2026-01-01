/// API'den güncel kur verilerini çeken servis (Altınkaynak)
/// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency_model.dart';

class ApiService {
  /// Altınkaynak - Döviz kurları ve altın fiyatları
  static const String _altinkaynakUrl = 'https://www.altinkaynak.com/canli-kurlar';

  /// Güncel döviz kurlarını ve altın fiyatlarını Altınkaynak'tan getir
  /// Hata durumunda null döndürür
  Future<List<CurrencyModel>?> getCurrencies() async {
    try {
      final response = await http.get(
        Uri.parse(_altinkaynakUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );

      if (response.statusCode == 200) {
        final html = response.body;
        final currencies = <CurrencyModel>[];

        // USD kurunu parse et
        final usdPrices = _parseCurrency(html, 'USD');
        if (usdPrices != null) {
          currencies.add(CurrencyModel(
            name: 'Amerikan Doları',
            code: 'USD',
            buyPrice: usdPrices['buy']!,
            sellPrice: usdPrices['sell']!,
          ));
        }

        // EUR kurunu parse et
        final eurPrices = _parseCurrency(html, 'EUR');
        if (eurPrices != null) {
          currencies.add(CurrencyModel(
            name: 'Euro',
            code: 'EUR',
            buyPrice: eurPrices['buy']!,
            sellPrice: eurPrices['sell']!,
          ));
        }

        // Altın fiyatını parse et
        final goldPrices = _parseGold(html);
        if (goldPrices != null) {
          currencies.add(CurrencyModel(
            name: 'Altın (Gram 24 Ayar)',
            code: 'GOLD',
            buyPrice: goldPrices['buy']!,
            sellPrice: goldPrices['sell']!,
          ));
        }

        if (currencies.isNotEmpty) {
          return currencies;
        } else {
          print('API Hatası: Kur verileri parse edilemedi');
          return null;
        }
      } else {
        print('API Hatası: Altınkaynak\'tan veri alınamadı: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('API Hatası: $e');
      return null;
    }
  }

  /// Döviz kuru parse et (USD veya EUR)
  Map<String, double>? _parseCurrency(String html, String code) {
    try {
      // Örnek: | USD | 43,060 | 43,202 | %0.00 |
      final pattern = RegExp(
        r'\|\s*' + code + r'\s*\|\s*([\d.,]+)\s*\|\s*([\d.,]+)',
        caseSensitive: false,
      );
      
      final match = pattern.firstMatch(html);
      
      if (match != null) {
        // Türkçe sayı formatını parse et (43,060 -> 43.060)
        final buyStr = match.group(1)!.replaceAll(',', '.');
        final sellStr = match.group(2)!.replaceAll(',', '.');
        
        return {
          'buy': double.parse(buyStr),
          'sell': double.parse(sellStr),
        };
      }
      return null;
    } catch (e) {
      print('$code parse hatası: $e');
      return null;
    }
  }

  /// Döviz kuru parse et (USD veya EUR)
  Map<String, double>? _parseCurrency(String html, String code) {
    try {
      // Örnek: | USD | 43,060 | 43,202 | %0.00 |
      final pattern = RegExp(
        r'\|\s*' + code + r'\s*\|\s*([\d.,]+)\s*\|\s*([\d.,]+)',
        caseSensitive: false,
      );
      
      final match = pattern.firstMatch(html);
      
      if (match != null) {
        // Türkçe sayı formatını parse et (43,060 -> 43.060)
        final buyStr = match.group(1)!.replaceAll(',', '.');
        final sellStr = match.group(2)!.replaceAll(',', '.');
        
        return {
          'buy': double.parse(buyStr),
          'sell': double.parse(sellStr),
        };
      }
      return null;
    } catch (e) {
      print('$code parse hatası: $e');
      return null;
    }
  }

  /// Altın fiyatını parse et (Gram 24 Ayar)
  Map<String, double>? _parseGold(String html) {
    try {
      // HTML'den "Gram (24 Ayar)" satırını bul
      // Örnek: | Gram (24 Ayar) | 6.143,66 | 6.269,62 | %0.19 |
      final gramPattern = RegExp(
        r'Gram\s*\(24\s*Ayar\)\s*[|]\s*([\d.,]+)\s*[|]\s*([\d.,]+)',
        caseSensitive: false,
      );
      
      final match = gramPattern.firstMatch(html);
      
      if (match != null) {
        // Türkçe sayı formatını parse et (6.143,66 -> 6143.66)
        final buyStr = match.group(1)!.replaceAll('.', '').replaceAll(',', '.');
        final sellStr = match.group(2)!.replaceAll('.', '').replaceAll(',', '.');
        
        return {
          'buy': double.parse(buyStr),
          'sell': double.parse(sellStr),
        };
      }
      return null;
    } catch (e) {
      print('Altın parse hatası: $e');
      return null;
    }
  }
}
