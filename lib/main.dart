import 'package:flutter/material.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/screens/changepassword_page/changepasword_page.dart';
import 'package:retreat/screens/forgetpassword_page/forgetpassword_page.dart';
import 'package:retreat/screens/home_page/home_page.dart';
import 'package:retreat/screens/setting_page/setting_page.dart';
import 'package:retreat/screens/signin_page/signin_page.dart';
import 'package:retreat/screens/signup_page/signup_page.dart';
import 'package:retreat/screens/record_transactions_page/record_transaction_page.dart';
import 'package:retreat/screens/splash_page/splash_page.dart';
import 'package:retreat/screens/transaction_list_pages/transaction_list_page.dart';
import 'package:retreat/screens/update_profile_page/update_profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://ztjtrovgvzujvwbeipqv.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp0anRyb3Zndnp1anZ3YmVpcHF2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTI2MjY0NjYsImV4cCI6MTk2ODIwMjQ2Nn0.6pgk8Fm47Sf_7mFb-UouZFqro49gUBLbesw7bQg6Ae4');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retreat',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.darkblue,
          onPrimary: AppColors.whiteshade,
          // Colors that are not relevant to AppBar in LIGHT mode:
          secondary: Colors.grey,
          onSecondary: Colors.grey,
          background: Colors.grey,
          onBackground: Colors.grey,
          surface: Colors.grey,
          onSurface: Colors.grey,
          error: Colors.grey,
          onError: Colors.grey,
        ),
      ),
      //home: const HomePage(),

      initialRoute: '/',
      routes: {
        '/': (_) => const SplashPage(),
        '/signin': (_) => const SignInPage(),
        '/forgetpassword': (_) => const ForgetPasswordPage(),
        '/signup': (_) => const SignUpPage(),
        '/home': (_) => const HomePage(),
        '/home/settings': (_) => const SettingPage(),
        '/home/settings/changepassword': (_) => const ChangePasswordPage(),
        '/home/settings/updateprofile': (_) => const UpdateProfilePage(),
        '/home/record': (_) => const RecordTransactionPage(),
        '/home/transactionlist': (_) => const TransactionListPage(),
        // '/home/transactionlist/display': (_) => const DisplayTransactionsPage(),
        // '/home/transactionlist/overview': (_) => const OverviewPage(),
      },
    );
  }
}
