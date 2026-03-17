import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/onboarding_view_model.dart';
import '../viewmodels/locale_view_model.dart';
import '../l10n/app_localizations.dart';
import 'login_view.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Öğrenciler İçin Not: Consumer widget'ı sayesinde sadece bu PopupMenuButton dil değiştiğinde yeniden çizilir.
          Consumer<LocaleViewModel>(
            builder: (context, localeViewModel, child) {
              return PopupMenuButton<String>(
                icon: Icon(Icons.language, color: Colors.blue[700]),
                tooltip: 'Select Language',
                // Kullanıcı listeden bir dil seçtiği zaman tetiklenen blok
                onSelected: (String languageCode) {
                  // Seçilen dili (languageCode: "en" veya "tr" gibi) ViewModel'e iletiyoruz.
                  localeViewModel.setLocale(Locale(languageCode));
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'en',
                    child: Text('English (EN)'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'tr',
                    child: Text('Türkçe (TR)'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'de',
                    child: Text('Deutsch (DE)'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(
                  'assets/images/onboarding_illustration.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      l10n.onboardingTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.onboardingDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Öğrenciler İçin Not: "Hemen Başla" butonu. Tıklandığında önce LocalStorage (SharedPreferences)'a "görüldü" olarak kaydederiz.
              ElevatedButton(
                onPressed: () async {
                  // OnboardingViewModel içindeki completeOnboarding() metodunu çağırıp kayıt atıyoruz.
                  await context.read<OnboardingViewModel>().completeOnboarding();
                  
                  // İşlem bittikten sonra UI kapatılmamışsa LoginView'a (Giriş) yönlendiriyoruz.
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginView()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.getStarted,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
