import 'package:flutter/material.dart';
import 'package:retreat/models/auth_required_state.dart';
import 'package:retreat/screens/update_transaction_page/update_transaction_tab.dart';
import 'package:retreat/models/transaction.dart';

/// this class represents the Update Transaction page which contains 2 tabs, Expense and Income
class UpdateTransactionPage extends StatefulWidget {
  const UpdateTransactionPage({Key? key, required this.initialTransaction})
      : super(key: key);

  final Transaction initialTransaction;

  @override
  State<UpdateTransactionPage> createState() => _UpdateTransactionPageState();
}

class _UpdateTransactionPageState
    extends AuthRequiredState<UpdateTransactionPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> nTabs = <Widget>[
      UpdateTransactionTab(
          isExpense: true, initialTransaction: widget.initialTransaction),
      UpdateTransactionTab(
          isExpense: false, initialTransaction: widget.initialTransaction),
    ];

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTransaction.isExpense ? 0 : 1,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "Expense"),
              Tab(text: "Income"),
            ],
          ),
          title: const Text('Update Transaction'),
        ),
        body: TabBarView(
          children: nTabs,
        ),
      ),
    );
  }
}
