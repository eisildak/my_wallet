import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';
import '../viewmodels/onboarding_view_model.dart';
import 'login_view.dart';
import 'dashboard_view.dart';
import 'onboarding_view.dart';

/// Öğrenciler İçin Not:
/// SplashView, uygulama ilk açıldığında ekranda görünen ve "yönlendirici" görevi gören sayfadır.
/// Kullanıcının nereye gideceğine (Onboarding, Login veya Dashboard) burada karar verilir.
class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Öğrenciler İçin Not: Logoyu en az 2 saniye ekranda göstermek için yapay bir gecikme (delay) eklendi.
    // await: Bu kodun bitmesini bekle demek. Bitmeden alttaki satıra geçmez.
    await Future.delayed(const Duration(seconds: 2));

    // widget ağacında hala aktif mi kontrolü. Eğer sayfa kapanmışsa işlemi kes.
    if (!mounted) return;

    // Provider (Consumer) ile önceden yüklenmiş durum yöneticilerini (ViewModel) okuyoruz.
    // Burada "listen: false" (read) kullandık çünkü state değişimi bizim UI'ımızı burada tetiklemesin, sadece okuyup karar verelim diye.
    final onboardingViewModel = context.read<OnboardingViewModel>();
    final authViewModel = context.read<AuthViewModel>();

    // Öğrenciler İçin Not: YÖNLENDİRME (ROUTING) MANTIĞI
    // 1. Kullanıcı uygulamayı İLK DEFA mı açıyor? (SharedPreferences'da kayıtlı değilse false döner)
    if (!onboardingViewModel.hasSeenOnboarding) {
      // pushReplacement: Geri dönülemeyecek şekilde yeni sayfaya geç. Çünkü Splash'e geri dönmemeli.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingView()),
      );
    } 
    // 2. Kullanıcı önceden giriş yapmış mı?
    else if (authViewModel.currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardView()),
      );
    } 
    // 3. Kullanıcı giriş yapmamışsa mecbur giriş ekranına yolla.
    else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash_screen.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 150,
                  color: Colors.blue[700],
                ),
              );
            },
          ),
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
