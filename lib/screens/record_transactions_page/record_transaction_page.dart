
import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/screens/record_transactions_page/record_expense_page.dart';
import 'package:retreat/screens/record_transactions_page/record_income_page.dart';
import 'package:retreat/widgets/custom_formfield.dart';
import 'package:retreat/services/transactions_service.dart';
import 'package:retreat/widgets/custom_dropdown.dart';
import 'package:retreat/widgets/numeric_formfield.dart';
import 'package:retreat/widgets/custom_button.dart';

class RecordTransactionPage extends StatefulWidget {
  const RecordTransactionPage({Key? key}) : super(key: key);

  @override
  State<RecordTransactionPage> createState() => _RecordTransactionPageState();
}

class _RecordTransactionPageState
    extends AuthRequiredState<RecordTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "Expense"),
              Tab(text: "Income"),
            ],
          ),
          title: Text('Record Transaction'),
        ),
        body: TabBarView(
          children: [
            RecordExpensePage(),
            RecordIncomePage(),
          ],
        ),
        
      ),
    );
  }
}
