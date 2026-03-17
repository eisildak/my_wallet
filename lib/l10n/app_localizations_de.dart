// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Finanzen Tracker';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get emailRequired => 'E-Mail-Adresse ist erforderlich';

  @override
  String get emailInvalid => 'Geben Sie eine gültige E-Mail ein';

  @override
  String get passwordRequired => 'Passwort ist erforderlich';

  @override
  String get passwordLengthError => 'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get login => 'Anmelden';

  @override
  String get noAccount => 'Sie haben noch kein Konto?';

  @override
  String get register => 'Registrieren';

  @override
  String get createAccount => 'Neues Konto erstellen';

  @override
  String get username => 'Benutzername';

  @override
  String get usernameRequired => 'Benutzername ist erforderlich';

  @override
  String get usernameLengthError => 'Benutzername muss mindestens 3 Zeichen lang sein';

  @override
  String get passwordConfirm => 'Passwort bestätigen';

  @override
  String get passwordConfirmRequired => 'Passwortbestätigung ist erforderlich';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String welcomeMessage(String username) {
    return 'Willkommen, $username';
  }

  @override
  String get currentRates => 'Aktuelle Kurse';

  @override
  String get sell => 'Verkauf';

  @override
  String get mySavings => 'Meine Ersparnisse';

  @override
  String get add => 'Hinzufügen';

  @override
  String get usdAmount => 'USD-Betrag';

  @override
  String get eurAmount => 'EUR-Betrag';

  @override
  String get goldGram => 'Gold (Gramm)';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get savingAddedSuccess => 'Ersparnisse erfolgreich hinzugefügt!';

  @override
  String get logout => 'Abmelden';

  @override
  String get totalAssetValue => 'Gesamtwert des Vermögens';

  @override
  String get noSavingsAdded => 'Sie haben noch keine Ersparnisse hinzugefügt.';

  @override
  String get onboardingTitle => 'Übernehmen Sie die Kontrolle';

  @override
  String get onboardingDescription => 'Verfolgen Sie Ihre Ersparnisse, sehen Sie aktuelle Wechselkurse und verwalten Sie Ihr Vermögen an einem Ort.';

  @override
  String get getStarted => 'Loslegen';
}
