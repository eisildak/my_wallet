# 🎓 FLUTTER ÖĞRENİM REHBERİ - DERS NOLARI

Bu doküman, "my_wallet" projesini inceleyerek Flutter'ı adım adım öğrenmeniz için hazırlanmıştır.

---

## 📚 DERS 1: Flutter Dünyasına Giriş ve Proje Yapısı

### Öğrenilen Kavramlar
- **"Her şey bir widget'tır"** felsefesi
- Flutter proje klasör yapısı
- MVVM (Model-View-ViewModel) mimarisi

### Proje Dosyalarını İnceleyin
1. `lib/main.dart` - Uygulamanın başladığı yer
2. `pubspec.yaml` - Projenin bağımlılıkları
3. `lib/` klasörü - Tüm kodların merkezi

### Pratik Görevler
```bash
# Projeyi oluşturun ve çalıştırın
flutter create deneme_app
cd deneme_app
flutter run
```

---

## 📚 DERS 2: Dart Dilinin Temelleri

### İncelenmesi Gereken Dosyalar
- `lib/models/currency_model.dart` - Class yapısı, constructor, factory method
- `lib/models/user_balance_model.dart` - Nesne yönelimli programlama

### Öğrenilen Kavramlar
```dart
// Değişkenler ve Tipler
String isim = "Flutter";
int sayi = 42;
double fiyat = 19.99;
bool aktif = true;

// Class tanımlama
class Urun {
  final String ad;
  final double fiyat;
  
  Urun({required this.ad, required this.fiyat});
}

// Factory constructor (JSON dönüşümü için)
factory Urun.fromJson(Map<String, dynamic> json) {
  return Urun(
    ad: json['ad'],
    fiyat: json['fiyat'],
  );
}
```

### Pratik Görevler
1. `currency_model.dart` dosyasını açın
2. `fromJson` metodunun nasıl çalıştığını inceleyin
3. Kendi model sınıfınızı oluşturun (örn: `ProductModel`)

---

## 📚 DERS 3: Temel Widget'lar ve UI İnşası

### İncelenmesi Gereken Dosyalar
- `lib/views/login_view.dart` - TextField, Button, Icon kullanımı
- `lib/views/register_view.dart` - Form validation

### Temel Widget'lar
```dart
// Metin gösterme
Text('Merhaba Flutter')

// Konteyner (kutu)
Container(
  color: Colors.blue,
  width: 100,
  height: 100,
  child: Text('İçerik'),
)

// Buton
ElevatedButton(
  onPressed: () {
    print('Tıklandı!');
  },
  child: Text('Tıkla'),
)

// Metin girişi
TextField(
  decoration: InputDecoration(labelText: 'İsminiz'),
  obscureText: false, // true olursa şifre gibi gizler
)
```

### Pratik Görevler
1. `login_view.dart` dosyasındaki TextField'ları inceleyin
2. `obscureText: true` parametresinin ne işe yaradığını test edin
3. Kendi basit bir form sayfanız oluşturun

---

## 📚 DERS 4: Layout (Yerleşim) Yönetimi

### İncelenmesi Gereken Dosyalar
- `lib/views/dashboard_view.dart` - Column, ListView, Card kullanımı

### Layout Widget'ları
```dart
// Alt alta dizmek (dikey)
Column(
  children: [
    Text('Birinci'),
    Text('İkinci'),
    Text('Üçüncü'),
  ],
)

// Yan yana dizmek (yatay)
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.person),
  ],
)

// Boşluk bırakma
SizedBox(height: 16), // Dikey boşluk
SizedBox(width: 16),  // Yatay boşluk

// Padding (iç boşluk)
Padding(
  padding: EdgeInsets.all(16.0),
  child: Text('Etrafımda boşluk var'),
)
```

### Pratik Görevler
1. `dashboard_view.dart` içindeki Column yapısını inceleyin
2. Row ile yan yana 3 ikon dizin
3. Column ile alt alta 3 metin kutucuğu oluşturun

---

## 📚 DERS 5: Listeler ve Dinamik İçerik

### İncelenmesi Gereken Dosyalar
- `lib/views/dashboard_view.dart` - ListView ve map kullanımı

### Liste Oluşturma
```dart
// Statik liste
ListView(
  children: [
    ListTile(title: Text('Öğe 1')),
    ListTile(title: Text('Öğe 2')),
    ListTile(title: Text('Öğe 3')),
  ],
)

// Dinamik liste (verilerden oluşturma)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
    );
  },
)

// Map ile liste dönüştürme
...currencies.map((currency) {
  return Card(
    child: ListTile(title: Text(currency.name)),
  );
}).toList()
```

### Pratik Görevler
1. `dashboard_view.dart` dosyasında kur listesinin nasıl oluşturulduğunu inceleyin
2. `...currencies.map()` satırını bulun ve nasıl çalıştığını anlayın
3. Kendi liste verilerinizle deneme yapın

---

## 📚 DERS 6: State Management (Durum Yönetimi)

### İncelenmesi Gereken Dosyalar
- `lib/viewmodels/auth_view_model.dart` - ChangeNotifier kullanımı
- `lib/views/login_view.dart` - Consumer widget'ı

### Stateful vs Stateless
```dart
// Stateless Widget (değişmeyen)
class MyStaticWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Ben hiç değişmem');
  }
}

// Stateful Widget (değişebilen)
class MyChangingWidget extends StatefulWidget {
  @override
  State<MyChangingWidget> createState() => _MyChangingWidgetState();
}

class _MyChangingWidgetState extends State<MyChangingWidget> {
  int counter = 0;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Sayaç: $counter'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              counter++;
            });
          },
          child: Text('Artır'),
        ),
      ],
    );
  }
}
```

### Provider Pattern
```dart
// ViewModel (durum yöneticisi)
class CounterViewModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners(); // Dinleyicilere haber ver
  }
}

// View'de kullanım
Consumer<CounterViewModel>(
  builder: (context, viewModel, child) {
    return Text('Sayı: ${viewModel.count}');
  },
)
```

### Pratik Görevler
1. `auth_view_model.dart` dosyasındaki `notifyListeners()` çağrılarını bulun
2. `login_view.dart` içindeki `Consumer<AuthViewModel>` yapısını inceleyin
3. Basit bir sayaç uygulaması yapın (StatefulWidget ile)

---

## 📚 DERS 7: Navigasyon ve Sayfa Geçişleri

### İncelenmesi Gereken Dosyalar
- `lib/views/login_view.dart` - Navigator.push kullanımı
- `lib/views/dashboard_view.dart` - Navigator.pushReplacement

### Navigasyon Komutları
```dart
// Yeni sayfaya git
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SecondPage()),
);

// Geri dön
Navigator.pop(context);

// Sayfayı değiştir (geri dönüş yok)
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => HomePage()),
);

// Veri göndererek sayfa aç
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailPage(productId: 123),
  ),
);
```

### Pratik Görevler
1. Login sayfasından Register'a geçişi inceleyin
2. Dashboard'dan Logout ile Login'e dönüşü analiz edin
3. İki sayfa arası veri gönderme/alma yapın

---

## 📚 DERS 8: HTTP İstekleri ve JSON İşleme

### İncelenmesi Gereken Dosyalar
- `lib/services/api_service.dart` - HTTP GET isteği
- `lib/models/currency_model.dart` - JSON parsing

### HTTP İsteği Yapma
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// GET isteği
Future<void> fetchData() async {
  final response = await http.get(
    Uri.parse('https://api.example.com/data'),
  );
  
  if (response.statusCode == 200) {
    // Başarılı
    var data = jsonDecode(response.body);
    print(data);
  } else {
    // Hata
    throw Exception('Veri alınamadı');
  }
}

// JSON'dan nesneye dönüşüm
final user = UserModel.fromJson(jsonData);
```

### Pratik Görevler
1. `api_service.dart` içindeki mock data fonksiyonunu inceleyin
2. Gerçek bir API'ye istek atın (örn: https://jsonplaceholder.typicode.com/posts)
3. JSON verisini model sınıfına dönüştürün

---

## 📚 DERS 9: Firebase Entegrasyonu

### İncelenmesi Gereken Dosyalar
- `lib/services/firebase_service.dart` - Auth ve Firestore işlemleri
- `lib/main.dart` - Firebase başlatma

### Firebase Authentication
```dart
// Kayıt olma
UserCredential userCredential = await FirebaseAuth.instance
    .createUserWithEmailAndPassword(
  email: email,
  password: password,
);

// Giriş yapma
UserCredential userCredential = await FirebaseAuth.instance
    .signInWithEmailAndPassword(
  email: email,
  password: password,
);

// Çıkış yapma
await FirebaseAuth.instance.signOut();
```

### Cloud Firestore
```dart
// Veri kaydetme
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .set({'name': 'Ali', 'age': 25});

// Veri okuma (Stream - gerçek zamanlı)
FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .snapshots()
    .listen((snapshot) {
  var data = snapshot.data();
  print(data);
});
```

### Pratik Görevler
1. Firebase Console'da proje oluşturun
2. `firebase_service.dart` dosyasını inceleyin
3. Kayıt/Giriş işlemlerini test edin

---

## 📚 DERS 10: MVVM Mimarisi ve Proje Organizasyonu

### Klasör Yapısı Mantığı

```
lib/
├── models/          → Veri yapıları (ne?)
├── services/        → Dış dünya ile bağlantı (nereden?)
├── viewmodels/      → İş mantığı (nasıl?)
└── views/           → Kullanıcı arayüzü (görsel)
```

### Katmanların Görevleri

**1. Models (Veri Modelleri)**
- Sadece veri yapısını tanımlar
- JSON dönüşümleri yapar
- İş mantığı içermez

**2. Services (Servisler)**
- API çağrıları yapar
- Firebase ile iletişim kurar
- Veritabanı işlemleri

**3. ViewModels (Görünüm Modelleri)**
- Servisten veriyi alır
- İş mantığını uygular
- View'e hazır veri sunar
- ChangeNotifier ile durum yönetimi

**4. Views (Görünümler)**
- Sadece UI widget'ları
- Provider/Consumer ile ViewModel'i dinler
- Kullanıcı etkileşimini yakalar

### Veri Akışı
```
User Action (View)
    ↓
ViewModel (mantık)
    ↓
Service (API/Firebase)
    ↓
Model (veri yapısı)
    ↓
ViewModel (işleme)
    ↓
View (gösterim)
```

### Pratik Görevler
1. Her klasördeki dosyaları tek tek inceleyin
2. Bir özelliğin (örn: Login) tüm katmanlardaki kodunu takip edin
3. Yeni bir özellik eklerken hangi dosyalara ne eklenmesi gerektiğini planlayın

---

## 🎯 KAPSAMLI UYGULAMA EGZERSİZİ

### Egzersiz 1: Yeni Bir Kur Ekle
1. `api_service.dart` içindeki mock data'ya Sterlin ekleyin
2. Dashboard'da gösterildiğini doğrulayın

### Egzersiz 2: Profil Sayfası Oluştur
1. `lib/views/profile_view.dart` dosyası oluşturun
2. Kullanıcı bilgilerini gösterin (isim, email)
3. Dashboard'dan profil sayfasına geçiş ekleyin

### Egzersiz 3: Birikim Silme Özelliği
1. Dashboard'a silme butonu ekleyin
2. Firestore'dan veriyi sıfırlama işlemi yapın
3. UI'ı güncelleyin

### Egzersiz 4: Tarihçe Sayfası
1. Yeni bir model oluşturun: `TransactionModel`
2. Her birikim ekleme işlemini kaydedin
3. Listeleyen bir sayfa yapın

---

## 🔍 DEBUG ve HATA GİDERME

### VS Code'da Debug
1. `F5` tuşuna basın
2. Breakpoint ekleyin (satır numarasına tıklayın)
3. Değişkenleri inceleyin

### Yaygın Hatalar
```dart
// ❌ Yanlış
Navigator.push(context, SecondPage());

// ✅ Doğru
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SecondPage()),
);

// ❌ Yanlış (async olmadan await)
void fetchData() {
  await http.get(url);
}

// ✅ Doğru
Future<void> fetchData() async {
  await http.get(url);
}
```

---

## 📖 ÖNERİLEN ÖĞRENME YOLU

### Hafta 1-2: Temel Kavramlar
- [ ] Ders 1-4: Widget'lar ve Layout
- [ ] Basit sayfa tasarımları yapın
- [ ] Her widget'ı Hot Reload ile test edin

### Hafta 3-4: State ve Navigasyon
- [ ] Ders 5-7: State management, navigasyon
- [ ] Çok sayfalı uygulama yapın
- [ ] Provider pattern'i anlayın

### Hafta 5-6: Backend Entegrasyonu
- [ ] Ders 8-9: HTTP ve Firebase
- [ ] API'den veri çeken uygulama yapın
- [ ] Firebase Auth ile login sistemi

### Hafta 7-8: Profesyonel Geliştirme
- [ ] Ders 10: MVVM mimarisi
- [ ] Kod organizasyonu yapın
- [ ] Kapsamlı proje geliştirin

---

## 🎓 FİNAL PROJESİ ÖNERİSİ

Öğrendiklerinizi pekiştirmek için bu projeyi yapın:

**E-Ticaret Uygulaması**
- [ ] Ürün listesi (API'den)
- [ ] Ürün detay sayfası
- [ ] Sepet sistemi (Firestore)
- [ ] Kullanıcı kayıt/giriş
- [ ] Sipariş geçmişi
- [ ] MVVM mimarisi

Bu proje ile tüm derslerdeki konuları kullanmış olursunuz!

---

## 📚 KAYNAKLAR

- [Flutter Resmi Dokümantasyon](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Widget Kataloğu](https://docs.flutter.dev/development/ui/widgets)
- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)

---

**Önemli Not:** Bu dersleri sırayla takip edin, her birinde kod yazın ve çalıştırın. Sadece okumak yeterli değil, mutlaka pratik yapın!

Başarılar! 🚀
