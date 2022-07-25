import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retreat/constants/app_theme.dart';
import 'package:retreat/notifiers/budget_list_change_notifier.dart';
import 'package:retreat/notifiers/category_list_change_notifier.dart';
import 'package:retreat/notifiers/current_profile_change_notifier.dart';
import 'package:retreat/notifiers/gamestat_change_notifier.dart';
import 'package:retreat/notifiers/island_change_notifier.dart';
import 'package:retreat/notifiers/shop_items_change_notifier.dart';
import 'package:retreat/notifiers/transaction_list_change_notifier.dart';
import 'package:retreat/screens/builder_shop_page/builder_shop_page.dart';
import 'package:retreat/screens/changepassword_page/changepasword_page.dart';
import 'package:retreat/screens/forgetpassword_page/forgetpassword_page.dart';
import 'package:retreat/screens/home_page/home_page.dart';
import 'package:retreat/screens/setting_page/setting_page.dart';
import 'package:retreat/screens/signin_page/signin_page.dart';
import 'package:retreat/screens/signup_page/signup_page.dart';
import 'package:retreat/screens/record_transactions_page/record_transaction_page.dart';
import 'package:retreat/screens/splash_page/splash_page.dart';
import 'package:retreat/screens/transaction_list_page/budget_history_tab.dart';
import 'package:retreat/screens/transaction_list_page/transaction_list_page.dart';
import 'package:retreat/screens/update_profile_page/update_profile_page.dart';
import 'package:retreat/services/budget_service.dart';
import 'package:retreat/services/category_service.dart';
import 'package:retreat/services/gamestat_service.dart';
import 'package:retreat/services/island_service.dart';
import 'package:retreat/services/profile_service.dart';
import 'package:retreat/services/shop_service.dart';
import 'package:retreat/services/transactions_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://ztjtrovgvzujvwbeipqv.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp0anRyb3Zndnp1anZ3YmVpcHF2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTI2MjY0NjYsImV4cCI6MTk2ODIwMjQ2Nn0.6pgk8Fm47Sf_7mFb-UouZFqro49gUBLbesw7bQg6Ae4');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (context) => IslandChangeNotifier(IslandService())),
    ChangeNotifierProvider(
        create: (context) => CurrentProfileChangeNotifier(ProfileService())),
    ChangeNotifierProvider(
        create: (context) =>
            TransactionListChangeNotifier(TransactionService())),
    ChangeNotifierProvider(
        create: (context) => CategoryListChangeNotifier(CategoryService())),
    ChangeNotifierProvider(
        create: (context) => BudgetListChangeNotifier(BudgetService())),
    ChangeNotifierProvider(
        create: (context) => GamestatChangeNotifier(GamestatService())),
    ChangeNotifierProvider(
        create: (context) => ShopItemsChangeNotifier(ShopService())),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.genIsland = true}) : super(key: key);

  final bool genIsland;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retreat',
      theme: AppTheme.darkMode,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashPage(),
        '/signin': (_) => const SignInPage(),
        '/forgetpassword': (_) => const ForgetPasswordPage(),
        '/signup': (_) => const SignUpPage(),
        '/home': (_) => HomePage(
              genIsland: genIsland,
            ),
        '/home/settings': (_) => const SettingPage(),
        '/home/settings/changepassword': (_) => const ChangePasswordPage(),
        '/home/settings/updateprofile': (_) => const UpdateProfilePage(),
        '/home/record': (_) => const RecordTransactionPage(),
        '/home/transactionlist': (_) => const TransactionListPage(),
        '/home/transactionlist/budget': (_) => const BudgetHistoryPage(),
        '/shop': (_) => const BuilderShopPage(),
      },
    );
  }
}
