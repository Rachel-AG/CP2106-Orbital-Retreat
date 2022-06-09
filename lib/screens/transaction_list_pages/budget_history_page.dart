import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';

class BudgetHistoryPage extends StatefulWidget {
  const BudgetHistoryPage({Key? key}) : super(key: key); //??

  @override
  State<BudgetHistoryPage> createState() => _BudgetHistoryPageState();
}

class _BudgetHistoryPageState extends AuthRequiredState<BudgetHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Budgets'),
        centerTitle: true,
      ),
      body: const Text('Insert budget history here'),
    );
  }
}
