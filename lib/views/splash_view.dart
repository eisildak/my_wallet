import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';
import '../viewmodels/onboarding_view_model.dart';
import 'login_view.dart';
import 'dashboard_view.dart';
import 'onboarding_view.dart';

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
    // Biraz bekleme süresi ekleyerek splash screen'in görünmesini sağlayabiliriz
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final onboardingViewModel = context.read<OnboardingViewModel>();
    final authViewModel = context.read<AuthViewModel>();

    // Eğer veri yükleniyorsa biraz daha bekle (Onboarding veya Auth state)
    // Gerçekte bunlar main.dart yüklenirken zaten memory'e alınmış olur ama
    // isLoading döngüleri asenkron tamamlanabilir.
    
    // Yönlendirme mantığı:
    if (!onboardingViewModel.hasSeenOnboarding) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingView()),
      );
    } else if (authViewModel.currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardView()),
      );
    } else {
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
