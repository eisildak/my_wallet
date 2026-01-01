/// API'den güncel kur verilerini çeken servis (TCMB - Merkez Bankası)
/// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/currency_model.dart';

class ApiService {
  /// TCMB (Türkiye Cumhuriyet Merkez Bankası) XML API
  static const String _tcmbUrl = 'https://www.tcmb.gov.tr/kurlar/today.xml';
  
  /// Altınkaynak - Altın fiyatları
  static const String _goldUrl = 'https://www.altinkaynak.com/canli-kurlar/altin';

  /// Güncel döviz kurlarını TCMB'den getir
  Future<List<CurrencyModel>> getCurrencies() async {
    try {
      final response = await http.get(Uri.parse(_tcmbUrl));

      if (response.statusCode == 200) {
        // XML'i parse et
        final document = XmlDocument.parse(response.body);
        final currencies = <CurrencyModel>[];

        // USD kurunu bul
        final usdElement = document.findAllElements('Currency')
            .firstWhere((element) => element.getAttribute('CurrencyCode') == 'USD');
        
        final usdBuy = double.parse(usdElement.findElements('ForexBuying').first.innerText);
        final usdSell = double.parse(usdElement.findElements('ForexSelling').first.innerText);
        
        currencies.add(CurrencyModel(
          name: 'Amerikan Doları',
          code: 'USD',
          buyPrice: usdBuy,
          sellPrice: usdSell,
        ));

        // EUR kurunu bul
        final eurElement = document.findAllElements('Currency')
            .firstWhere((element) => element.getAttribute('CurrencyCode') == 'EUR');
        
        final eurBuy = double.parse(eurElement.findElements('ForexBuying').first.innerText);
        final eurSell = double.parse(eurElement.findElements('ForexSelling').first.innerText);
        
        currencies.add(CurrencyModel(
          name: 'Euro',
          code: 'EUR',
          buyPrice: eurBuy,
          sellPrice: eurSell,
        ));

        // Altın fiyatı - Altınkaynak'tan çek
        final goldPrices = await _getGoldPrice();
        currencies.add(CurrencyModel(
          name: 'Altın (Gram 24 Ayar)',
          code: 'GOLD',
          buyPrice: goldPrices['buy']!,
          sellPrice: goldPrices['sell']!,
        ));

        return currencies;
      } else {
        throw Exception('TCMB\'den veri alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      // Hata durumunda mock data döndür
      print('API Hatası: $e - Mock data kullanılıyor');
      return _getMockCurrencies();
    }
  }

  /// Altınkaynak'tan gram altın fiyatlarını çek
  Future<Map<String, double>> _getGoldPrice() async {
    try {
      final response = await http.get(
        Uri.parse(_goldUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );

      if (response.statusCode == 200) {
        final html = response.body;
        
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
      }
      
      // Parse edilemezse varsayılan değer döndür
      throw Exception('Altın fiyatı parse edilemedi');
    } catch (e) {
      print('Altın fiyatı çekilemedi: $e - Varsayılan değer kullanılıyor');
      return {'buy': 6143.66, 'sell': 6269.62};
    }
  }

  /// Yedek mock (sahte) veri
  List<CurrencyModel> _getMockCurrencies() {
    return [
      CurrencyModel(
        name: 'Amerikan Doları',
        code: 'USD',
        buyPrice: 32.45,
        sellPrice: 32.58,
      ),
      CurrencyModel(
        name: 'Euro',
        code: 'EUR',
        buyPrice: 35.82,
        sellPrice: 35.96,
      ),
      CurrencyModel(
        name: 'Altın (Gram 24 Ayar)',
        code: 'GOLD',
        buyPrice: 6143.66,
        sellPrice: 6269.62,
      ),
    ];
  }
}
