/// API'den güncel kur verilerini çeken servis (TCMB - Merkez Bankası)
/// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/currency_model.dart';

class ApiService {
  /// TCMB (Türkiye Cumhuriyet Merkez Bankası) XML API
  static const String _tcmbUrl = 'https://www.tcmb.gov.tr/kurlar/today.xml';

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

        // Altın fiyatı (TCMB'de altın yok, sabit değer kullanıyoruz)
        // Gerçek altın fiyatı için ayrı bir API kullanılabilir
        currencies.add(CurrencyModel(
          name: 'Altın (Gram)',
          code: 'GOLD',
          buyPrice: 2847.50,
          sellPrice: 2858.20,
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
        name: 'Altın (Gram)',
        code: 'GOLD',
        buyPrice: 2847.50,
        sellPrice: 2858.20,
      ),
    ];
  }
}
