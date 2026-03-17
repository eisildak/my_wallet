// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Financial Tracker';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailRequired => 'Email address is required';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordLengthError => 'Password must be at least 6 characters';

  @override
  String get login => 'Login';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get register => 'Register';

  @override
  String get createAccount => 'Create New Account';

  @override
  String get username => 'Username';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get usernameLengthError => 'Username must be at least 3 characters';

  @override
  String get passwordConfirm => 'Confirm Password';

  @override
  String get passwordConfirmRequired => 'Password confirmation is required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String welcomeMessage(String username) {
    return 'Welcome, $username';
  }

  @override
  String get currentRates => 'Current Rates';

  @override
  String get sell => 'Sell';

  @override
  String get mySavings => 'My Savings';

  @override
  String get add => 'Add';

  @override
  String get usdAmount => 'USD Amount';

  @override
  String get eurAmount => 'EUR Amount';

  @override
  String get goldGram => 'Gold (Gram)';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get savingAddedSuccess => 'Savings added successfully!';

  @override
  String get logout => 'Logout';

  @override
  String get totalAssetValue => 'Total Asset Value';

  @override
  String get noSavingsAdded => 'You haven\'t added any savings yet.';

  @override
  String get onboardingTitle => 'Take Control of Your Finances';

  @override
  String get onboardingDescription => 'Track your savings, view current exchange rates, and manage your assets all in one place.';

  @override
  String get getStarted => 'Get Started';
}
