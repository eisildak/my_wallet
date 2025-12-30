# 💰 Finansal Takip Uygulaması

Flutter ile geliştirilmiş, kur ve birikim yönetimi yapabileceğiniz bir mobil uygulama.

## 📱 Özellikler

- ✅ Kullanıcı kayıt ve giriş sistemi (Firebase Authentication)
- ✅ Güncel döviz kurları (Dolar, Euro, Altın)
- ✅ Kişisel birikim takibi
- ✅ Toplam varlık değeri hesaplama (TL cinsinden)
- ✅ Gerçek zamanlı veri senkronizasyonu (Cloud Firestore)
- ✅ MVVM mimarisi (Model-View-ViewModel)

## 🏗️ Proje Yapısı

```
my_wallet/
├── lib/
│   ├── models/                 # Veri modelleri
│   │   ├── currency_model.dart
│   │   └── user_balance_model.dart
│   ├── services/              # Dış servisler (API, Firebase)
│   │   ├── api_service.dart
│   │   └── firebase_service.dart
│   ├── viewmodels/            # İş mantığı katmanı
│   │   ├── auth_view_model.dart
│   │   └── finance_view_model.dart
│   ├── views/                 # Kullanıcı arayüzü
│   │   ├── login_view.dart
│   │   ├── register_view.dart
│   │   └── dashboard_view.dart
│   └── main.dart              # Uygulama giriş noktası
└── pubspec.yaml               # Bağımlılıklar
```

## 🚀 Kurulum Adımları

### 1. Flutter SDK Kurulumu (Windows)

1. [Flutter SDK](https://docs.flutter.dev/get-started/install/windows) indirin
2. İndirdiğiniz ZIP dosyasını `C:\src\flutter` gibi bir klasöre çıkartın
3. Sistem ortam değişkenlerine Flutter'ı ekleyin:
   - Windows Arama → "Ortam Değişkenleri"
   - `Path` değişkenine `C:\src\flutter\bin` ekleyin

4. Terminalde doğrulama yapın:
```bash
flutter doctor
```

### 2. Android Studio Kurulumu

1. [Android Studio](https://developer.android.com/studio) indirin ve kurun
2. Android Studio'yu açın → "More Actions" → "SDK Manager"
3. Android SDK ve Android SDK Command-line Tools'u yükleyin
4. "Virtual Device Manager" ile emülatör oluşturun

### 3. VS Code Kurulumu

1. [VS Code](https://code.visualstudio.com/) indirin ve kurun
2. Extensions sekmesinden şu eklentileri yükleyin:
   - **Flutter** (Dart-Code.flutter)
   - **Dart** (Dart-Code.dart-code)

### 4. Projeyi Çalıştırma

VS Code terminalinde (`Ctrl + \``) şu komutları çalıştırın:

```bash
# 1. Bağımlılıkları yükle
flutter pub get

# 2. Android emülatörü başlat (veya fiziksel cihaz bağlayın)
# Android Studio'dan emülatör başlatın veya:
flutter emulators --launch <emulator_id>

# 3. Uygulamayı çalıştır
flutter run
```

## ⚙️ Firebase Yapılandırması (İsteğe Bağlı)

Uygulamayı gerçek Firebase ile kullanmak için:

### Adım 1: Firebase Projesi Oluşturma
1. [Firebase Console](https://console.firebase.google.com/) üzerinden yeni proje oluşturun
2. Android uygulaması ekleyin
3. Paket adı: `com.example.my_wallet`
4. `google-services.json` dosyasını indirin

### Adım 2: Yapılandırma Dosyası
İndirdiğiniz `google-services.json` dosyasını şu konuma kopyalayın:
```
my_wallet/android/app/google-services.json
```

### Adım 3: Gradle Yapılandırması
[android/build.gradle](android/build.gradle#L8) dosyasına:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
}
```

[android/app/build.gradle](android/app/build.gradle#L5) dosyasına:
```gradle
apply plugin: 'com.google.gms.google-services'
```

### Adım 4: Firebase Servislerini Aktifleştir
Firebase Console'da:
- **Authentication** → Email/Password'ü etkinleştirin
- **Cloud Firestore** → Veritabanı oluşturun (test modunda)

### Adım 5: Kodu Güncelle
[lib/main.dart](lib/main.dart#L14) dosyasında Firebase başlatma satırının yorumunu kaldırın:
```dart
await Firebase.initializeApp();
```

## 🧪 Firebase Olmadan Test Etme

Firebase olmadan test etmek için:
1. [lib/main.dart](lib/main.dart#L14) dosyasında Firebase başlatma satırını yorumda bırakın
2. [lib/services/api_service.dart](lib/services/api_service.dart#L21) mock data kullanıyor (varsayılan)
3. Firebase servisleri çalışmayacaktır (kayıt/giriş işlemleri hata verir)

**Önerilen Geliştirme Akışı:**
- İlk aşamada UI'ı test etmek için Firebase olmadan çalıştırın
- Ardından Firebase'i yapılandırarak tam fonksiyonelliği test edin

## 📖 Kullanım

### Kayıt Olma
1. Uygulamayı açın
2. "Kayıt Ol" butonuna tıklayın
3. Kullanıcı adı, e-posta ve şifre girin
4. "Kayıt Ol" ile hesabınızı oluşturun

### Giriş Yapma
1. Ana ekranda e-posta ve şifrenizi girin
2. "Giriş Yap" butonuna tıklayın

### Birikim Ekleme
1. Dashboard'da "Ekle" butonuna tıklayın
2. Dolar, Euro ve Altın miktarlarınızı girin
3. "Kaydet" ile birikimlerinizi saklayın
4. Toplam varlık değerinizi TL cinsinden görün

## 🛠️ Kullanılan Teknolojiler

- **Flutter 3.0+** - Cross-platform UI framework
- **Dart** - Programlama dili
- **Provider** - State management
- **Firebase Auth** - Kullanıcı kimlik doğrulama
- **Cloud Firestore** - NoSQL veritabanı
- **HTTP** - API istekleri

## 📚 Öğrenilen Konular

Bu proje ile şunları öğrenebilirsiniz:

1. **Flutter Widget'ları**: TextField, Button, ListView, Card
2. **Layout Yönetimi**: Column, Row, Container, Padding
3. **State Management**: Provider pattern kullanımı
4. **Navigasyon**: Sayfalar arası geçiş ve veri aktarımı
5. **HTTP İstekleri**: JSON parsing ve API entegrasyonu
6. **Firebase**: Authentication ve Firestore CRUD işlemleri
7. **MVVM Mimarisi**: Kod organizasyonu ve katmanlı yapı

## 🐛 Hata Giderme

### "Flutter SDK not found"
```bash
# Flutter PATH'inin doğru olduğunu kontrol edin:
where flutter
```

### "No devices found"
```bash
# Bağlı cihazları listeleyin:
flutter devices

# Emülatör başlatın:
flutter emulators --launch Pixel_5_API_33
```

### "Packages get failed"
```bash
# Cache'i temizleyip tekrar deneyin:
flutter clean
flutter pub get
```

### Firebase bağlantı hatası
- `google-services.json` dosyasının doğru yerde olduğunu kontrol edin
- Firebase Console'da Authentication ve Firestore'un aktif olduğunu doğrulayın

## 📝 Notlar

- **API Anahtarı**: Gerçek kur verileri için [CollectAPI](https://collectapi.com/) veya benzeri bir servisten API anahtarı almanız gerekir
- **Mock Data**: Şu anda uygulama mock (sahte) kur verileri kullanıyor
- **Platform**: Bu proje öncelikle Android için hazırlanmıştır, iOS için ek yapılandırma gerekebilir

## 📄 Lisans

Bu proje eğitim amaçlıdır ve MIT lisansı altında sunulmaktadır.

## 👨‍💻 Geliştirici

Flutter öğrenme serisi kapsamında hazırlanmıştır.

---

**Başarılar! Happy Coding! 🚀**
