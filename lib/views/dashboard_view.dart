/// Ana sayfa - Güncel kurlar ve kullanıcı bakiyesi
/// lib/views/dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wallet/l10n/app_localizations.dart';
import '../viewmodels/finance_view_model.dart';
import '../viewmodels/auth_view_model.dart';
import '../viewmodels/locale_view_model.dart';
import 'login_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _usdController = TextEditingController();
  final _eurController = TextEditingController();
  final _goldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final financeViewModel = Provider.of<FinanceViewModel>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    
    // Kurları çek
    await financeViewModel.fetchCurrencies();
    
    // Kullanıcı bakiyesini yükle
    if (authViewModel.currentUser != null) {
      await financeViewModel.loadBalance(authViewModel.currentUser!['uid']);
    }
  }

  @override
  void dispose() {
    _usdController.dispose();
    _eurController.dispose();
    _goldController.dispose();
    super.dispose();
  }

  void _showAddBalanceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.mySavings),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.usdAmount,
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _eurController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.eurAmount,
                    prefixIcon: const Icon(Icons.euro),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _goldController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.goldGram,
                    prefixIcon: const Icon(Icons.diamond),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final financeViewModel = Provider.of<FinanceViewModel>(context, listen: false);
                final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                
                if (authViewModel.currentUser != null) {
                  // Mevcut bakiyeyi al
                  final currentBalance = financeViewModel.userBalance;
                  final currentUsd = currentBalance?.usdAmount ?? 0;
                  final currentEur = currentBalance?.eurAmount ?? 0;
                  final currentGold = currentBalance?.goldGram ?? 0;
                  
                  // Yeni girilen değerleri mevcut bakiyeye EKLE
                  await financeViewModel.updateBalance(
                    userId: authViewModel.currentUser!['uid'],
                    usdAmount: currentUsd + (double.tryParse(_usdController.text) ?? 0),
                    eurAmount: currentEur + (double.tryParse(_eurController.text) ?? 0),
                    goldGram: currentGold + (double.tryParse(_goldController.text) ?? 0),
                  );
                  
                  _usdController.clear();
                  _eurController.clear();
                  _goldController.clear();
                  
                  if (mounted) {
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.savingAddedSuccess)),
                    );
                  }
                }
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.logout();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icons/app_icon_transparent.png',
              height: 32,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance_wallet, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(l10n.appTitle),
          ],
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          Consumer<LocaleViewModel>(
            builder: (context, localeViewModel, child) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.language),
                tooltip: 'Select Language',
                onSelected: (String languageCode) {
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: l10n.logout,
          ),
        ],
      ),
      body: Consumer<FinanceViewModel>(
        builder: (context, financeViewModel, child) {
          if (financeViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => financeViewModel.fetchCurrencies(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: 16.0 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kullanıcı bilgisi
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Consumer<AuthViewModel>(
                            builder: (context, authViewModel, child) {
                              final username = authViewModel.currentUser?['username'] ?? 'Kullanıcı';
                              return Text(
                                l10n.welcomeMessage(username),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Güncel Kurlar Başlığı
                  Text(
                    l10n.currentRates,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Kur Listesi
                  ...financeViewModel.currencies.map((currency) {
                    IconData icon;
                    Color color;
                    
                    switch (currency.code) {
                      case 'USD':
                        icon = Icons.attach_money;
                        color = Colors.green;
                        break;
                      case 'EUR':
                        icon = Icons.euro;
                        color = Colors.blue;
                        break;
                      case 'GOLD':
                        icon = Icons.diamond;
                        color = Colors.amber;
                        break;
                      default:
                        icon = Icons.monetization_on;
                        color = Colors.grey;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withOpacity(0.2),
                          child: Icon(icon, color: color),
                        ),
                        title: Text(
                          currency.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(currency.code),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${currency.buyPrice.toStringAsFixed(2)} ₺',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${l10n.sell}: ${currency.sellPrice.toStringAsFixed(2)} ₺',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Birikimlerim Başlığı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.mySavings,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showAddBalanceDialog,
                        icon: const Icon(Icons.add),
                        label: Text(l10n.add),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Birikim Kartları
                  if (financeViewModel.userBalance != null) ...[
                    _buildBalanceCard(
                      'Dolar',
                      financeViewModel.userBalance!.usdAmount,
                      Icons.attach_money,
                      Colors.green,
                    ),
                    _buildBalanceCard(
                      'Euro',
                      financeViewModel.userBalance!.eurAmount,
                      Icons.euro,
                      Colors.blue,
                    ),
                    _buildBalanceCard(
                      'Altın (Gram)',
                      financeViewModel.userBalance!.goldGram,
                      Icons.diamond,
                      Colors.amber,
                    ),

                    const SizedBox(height: 16),

                    // Toplam Değer
                    Card(
                      color: Colors.blue[700],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.totalAssetValue,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${financeViewModel.getTotalValueInTRY().toStringAsFixed(2)} ₺',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(l10n.noSavingsAdded),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceCard(String title, double amount, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          amount.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
