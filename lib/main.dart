/// Uygulamanın giriş noktası
/// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/viewmodels/auth_view_model.dart';
import 'package:my_wallet/viewmodels/finance_view_model.dart';
import 'package:my_wallet/viewmodels/locale_view_model.dart';
import 'package:my_wallet/viewmodels/onboarding_view_model.dart';
import 'package:my_wallet/views/splash_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_wallet/l10n/app_localizations.dart';

void main() async {
  // Flutter binding'i başlat
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyWalletApp());
}

class MyWalletApp extends StatelessWidget {
  const MyWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider ile ViewModelleri uygulamaya enjekte ediyoruz
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => FinanceViewModel()),
        ChangeNotifierProvider(create: (_) => LocaleViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
      ],
      child: Consumer<LocaleViewModel>(
        builder: (context, localeViewModel, child) {
          if (localeViewModel.isLoading) {
             return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
          }
          return MaterialApp(
            title: 'Finansal Takip',
            debugShowCheckedModeBanner: false,
            locale: localeViewModel.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('tr', ''), // Turkish
              Locale('de', ''), // German
            ],
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
            ),
            // Uygulama açılışta SplashView sayfasını gösterir
            home: const SplashView(),
          );
        },
      ),
    );
  }
}
