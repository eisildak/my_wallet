/// Kullanıcının sahip olduğu varlıkları temsil eden model sınıfı
/// lib/models/user_balance_model.dart
class UserBalanceModel {
  final String userId;
  final double usdAmount;
  final double eurAmount;
  final double goldGram;
  final DateTime lastUpdated;

  UserBalanceModel({
    required this.userId,
    required this.usdAmount,
    required this.eurAmount,
    required this.goldGram,
    required this.lastUpdated,
  });

  /// Firestore'dan gelen veriyi Dart nesnesine dönüştürme
  factory UserBalanceModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserBalanceModel(
      userId: uid,
      usdAmount: (data['usdAmount'] ?? 0).toDouble(),
      eurAmount: (data['eurAmount'] ?? 0).toDouble(),
      goldGram: (data['goldGram'] ?? 0).toDouble(),
      lastUpdated: data['lastUpdated'] != null 
          ? DateTime.parse(data['lastUpdated'])
          : DateTime.now(),
    );
  }

  /// Firestore'a kaydetmek için Map'e dönüştürme
  Map<String, dynamic> toFirestore() {
    return {
      'usdAmount': usdAmount,
      'eurAmount': eurAmount,
      'goldGram': goldGram,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Boş/başlangıç balance oluşturma
  factory UserBalanceModel.empty(String uid) {
    return UserBalanceModel(
      userId: uid,
      usdAmount: 0,
      eurAmount: 0,
      goldGram: 0,
      lastUpdated: DateTime.now(),
    );
  }
}
