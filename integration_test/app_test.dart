import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:retreat/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:retreat/notifiers/budget_list_change_notifier.dart';
import 'package:retreat/notifiers/category_list_change_notifier.dart';
import 'package:retreat/notifiers/current_profile_change_notifier.dart';
import 'package:retreat/notifiers/island_change_notifier.dart';
import 'package:retreat/notifiers/transaction_list_change_notifier.dart';
import 'package:retreat/services/budget_service.dart';
import 'package:retreat/services/category_service.dart';
import 'package:retreat/services/island_service.dart';
import 'package:retreat/services/profile_service.dart';
import 'package:retreat/services/transactions_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> initSupabase() async {
    await Supabase.initialize(
        url: 'https://ztjtrovgvzujvwbeipqv.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp0anRyb3Zndnp1anZ3YmVpcHF2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTI2MjY0NjYsImV4cCI6MTk2ODIwMjQ2Nn0.6pgk8Fm47Sf_7mFb-UouZFqro49gUBLbesw7bQg6Ae4');
  }

  void initProvider() {
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
          create: (context) => BudgetListChangeNotifier(BudgetService()))
    ], child: const MyApp()));
  }

  Future<void> addDelay(int ms) async {
    await Future<void>.delayed(Duration(milliseconds: ms));
  }

  void onCurrentPage(WidgetTester tester, String page) {
    expect(find.text(page), findsOneWidget);
    tester.printToConsole('-----$page page opened successfully-----');
  }

  group('Authentication Test', () {
    final timeBasedEmail = '${DateTime.now().microsecondsSinceEpoch}@test.com';
    final timeBasedPassword = '${DateTime.now().microsecondsSinceEpoch}';

    testWidgets('Sign-up using a randomly generated email and sign-out',
        (WidgetTester tester) async {
      await initSupabase();
      initProvider();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Sign In');

      await tester.tap(find.byKey(const ValueKey('sign-up-link')));
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Sign Up');

      await tester.enterText(
          find.byKey(const ValueKey('username-field')), 'Tester');
      await tester.enterText(
          find.byKey(const ValueKey('email-field')), timeBasedEmail);
      await tester.enterText(
          find.byKey(const ValueKey('password-field')), 'test123');

      await tester.tap(find.byKey(const ValueKey('sign-up-button')));
      await addDelay(3000);
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Home');

      await tester.tap(find.byKey(const ValueKey('settings')));
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Settings');

      await tester.tap(find.byKey(const ValueKey('sign-out-button')));
      await addDelay(3000);
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Sign In');
    });

    testWidgets('Sign-in using a registered email and sign-out',
        (WidgetTester tester) async {
      initProvider();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Sign In');

      await tester.enterText(find.byKey(const ValueKey('email-field')),
          'retreat.test123@gmail.com');
      await tester.enterText(
          find.byKey(const ValueKey('password-field')), 'test123');

      await tester.tap(find.byKey(const ValueKey('sign-in-button')));
      await addDelay(3000);
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Home');

      await tester.tap(find.byKey(const ValueKey('settings')));
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Settings');

      await tester.tap(find.byKey(const ValueKey('sign-out-button')));
      await addDelay(3000);
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Sign In');
    });

    testWidgets('Sign-in using a randomly generated email and password',
        (WidgetTester tester) async {
      initProvider();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Sign In');

      await tester.enterText(
          find.byKey(const ValueKey('email-field')), timeBasedEmail);
      await tester.enterText(
          find.byKey(const ValueKey('password-field')), timeBasedPassword);

      await tester.tap(find.byKey(const ValueKey('sign-in-button')));
      await addDelay(3000);
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Sign In');
    });

    testWidgets('Sign-up using an already registered email',
        (WidgetTester tester) async {
      initProvider();
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Sign In');

      await tester.tap(find.byKey(const ValueKey('sign-up-link')));
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Sign Up');

      await tester.enterText(
          find.byKey(const ValueKey('username-field')), 'Tester');
      await tester.enterText(find.byKey(const ValueKey('email-field')),
          'retreat.test123@gmail.com');
      await tester.enterText(
          find.byKey(const ValueKey('password-field')), 'test123');

      await tester.tap(find.byKey(const ValueKey('sign-up-button')));
      await addDelay(3000);
      await tester.pumpAndSettle();

      onCurrentPage(tester, 'Sign Up');
    });
  });
}
