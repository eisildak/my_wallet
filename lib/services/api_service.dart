/// API'den güncel kur verilerini çeken servis (Altınkaynak)
/// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/currency_model.dart';

class ApiService {
  /// Truncgil API - Altın fiyatları için
  static const String _truncgilUrl = 'https://finans.truncgil.com/today.json';
  /// TCMB Kurları XML servisi
  static const String _tcmbUrl = 'https://www.tcmb.gov.tr/kurlar/today.xml';

  /// Güncel döviz kurlarını TCMB'den, altın fiyatlarını Truncgil'den getir
  /// Hata durumunda null döndürür
  Future<List<CurrencyModel>?> getCurrencies() async {
    try {
      final currencies = <CurrencyModel>[];

      // 1. TCMB'den USD ve EUR verilerini çek
      try {
        final tcmbResponse = await http.get(Uri.parse(_tcmbUrl));
        if (tcmbResponse.statusCode == 200) {
          final document = XmlDocument.parse(tcmbResponse.body);
          final elements = document.findAllElements('Currency');
          
          for (var element in elements) {
            final currencyCode = element.getAttribute('CurrencyCode');
            if (currencyCode == 'USD' || currencyCode == 'EUR') {
              final forexBuyingStr = element.findElements('ForexBuying').first.text;
              final forexSellingStr = element.findElements('ForexSelling').first.text;

              final buyPrice = double.tryParse(forexBuyingStr) ?? 0.0;
              final sellPrice = double.tryParse(forexSellingStr) ?? 0.0;
              
              if (buyPrice > 0 && sellPrice > 0) {
                 currencies.add(CurrencyModel(
                  name: currencyCode == 'USD' ? 'Amerikan Doları' : 'Euro',
                  code: currencyCode!,
                  buyPrice: buyPrice,
                  sellPrice: sellPrice,
                ));
              }
            }
          }
        } else {
          print('API Hatası: TCMB verileri alınamadı: ${tcmbResponse.statusCode}');
        }
      } catch (e) {
        print('TCMB API Hatası: $e');
      }

      // 2. Truncgil Finans'tan Altın verisini çek
      try {
        final altinResponse = await http.get(Uri.parse(_truncgilUrl));

        if (altinResponse.statusCode == 200) {
          final jsonData = json.decode(altinResponse.body);
          if (jsonData.containsKey('gram-altin')) {
            final goldData = jsonData['gram-altin'];
            final buyStr = goldData['Alış'].toString().replaceAll('.', '').replaceAll(',', '.');
            final sellStr = goldData['Satış'].toString().replaceAll('.', '').replaceAll(',', '.');
            
            currencies.add(CurrencyModel(
              name: 'Altın (Gram 24 Ayar)',
              code: 'GOLD',
              buyPrice: double.tryParse(buyStr) ?? 0.0,
              sellPrice: double.tryParse(sellStr) ?? 0.0,
            ));
          }
        } else {
          print('API Hatası: Truncgil verileri alınamadı: ${altinResponse.statusCode}');
        }
      } catch (e) {
        print('Truncgil API Hatası: $e');
      }

      if (currencies.isNotEmpty) {
        return currencies;
      } else {
        print('API Hatası: Hiçbir kur verisi alınamadı');
        return null;
      }
      
    } catch (e) {
      print('Genel API Hatası: $e');
      return null;
    }
  }

}
