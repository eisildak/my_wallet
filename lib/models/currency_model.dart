/// API'den gelen kur verilerini temsil eden model sınıfı
/// lib/models/currency_model.dart
class CurrencyModel {
  final String name;
  final String code;
  final double buyPrice;
  final double sellPrice;

  CurrencyModel({
    required this.name,
    required this.code,
    required this.buyPrice,
    required this.sellPrice,
  });

  /// JSON'dan Dart nesnesine dönüşüm (API'den gelen veriyi işlemek için)
  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      buyPrice: (json['buying'] ?? 0).toDouble(),
      sellPrice: (json['selling'] ?? 0).toDouble(),
    );
  }

  /// Dart nesnesinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'buying': buyPrice,
      'selling': sellPrice,
    };
  }
}
