import 'package:flutter/material.dart';
import 'package:retreat/models/auth_required_state.dart';
import 'package:retreat/screens/record_transactions_page/record_transaction_tab.dart';

/// this class represents record transaction page
class RecordTransactionPage extends StatefulWidget {
  const RecordTransactionPage({Key? key}) : super(key: key);

  @override
  State<RecordTransactionPage> createState() => _RecordTransactionPageState();
}

class _RecordTransactionPageState
    extends AuthRequiredState<RecordTransactionPage> {
  List<Widget> nTabs = <Widget>[
    const RecordTransactionTab(
      isExpense: true,
    ),
    const RecordTransactionTab(isExpense: false)
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Expense"),
              Tab(text: "Income"),
            ],
          ),
          title: const Text('Record Transaction'),
        ),
        body: TabBarView(
          children: nTabs,
        ),
      ),
    );
  }
}
