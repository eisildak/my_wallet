// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Finansal Takip';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get emailRequired => 'E-posta adresi gerekli';

  @override
  String get emailInvalid => 'Geçerli bir e-posta girin';

  @override
  String get passwordRequired => 'Şifre gerekli';

  @override
  String get passwordLengthError => 'Şifre en az 6 karakter olmalı';

  @override
  String get login => 'Giriş Yap';

  @override
  String get noAccount => 'Hesabınız yok mu?';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get createAccount => 'Yeni Hesap Oluştur';

  @override
  String get username => 'Kullanıcı Adı';

  @override
  String get usernameRequired => 'Kullanıcı adı gerekli';

  @override
  String get usernameLengthError => 'Kullanıcı adı en az 3 karakter olmalı';

  @override
  String get passwordConfirm => 'Şifre Tekrar';

  @override
  String get passwordConfirmRequired => 'Şifre tekrarı gerekli';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String welcomeMessage(String username) {
    return 'Hoş geldin, $username';
  }

  @override
  String get currentRates => 'Güncel Kurlar';

  @override
  String get sell => 'Satış';

  @override
  String get mySavings => 'Birikimlerim';

  @override
  String get add => 'Ekle';

  @override
  String get usdAmount => 'Dolar Miktarı';

  @override
  String get eurAmount => 'Euro Miktarı';

  @override
  String get goldGram => 'Altın (Gram)';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get savingAddedSuccess => 'Birikim başarıyla eklendi!';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get totalAssetValue => 'Toplam Varlık Değeri';

  @override
  String get noSavingsAdded => 'Henüz birikim eklemediniz.';

  @override
  String get onboardingTitle => 'Finansal Kontrolü Eline Al';

  @override
  String get onboardingDescription => 'Birikimlerini takip et, güncel kurları görüntüle ve varlıklarını tek bir yerden yönet.';

  @override
  String get getStarted => 'Hemen Başla';
}
