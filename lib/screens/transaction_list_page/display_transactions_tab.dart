import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/transaction.dart';
import 'package:retreat/notifiers/transaction_list_change_notifier.dart';
import 'package:retreat/screens/update_transaction_page/update_transaction_page.dart';

class DisplayTransactionsPage extends StatefulWidget {
  const DisplayTransactionsPage({Key? key}) : super(key: key); //??

  @override
  State<DisplayTransactionsPage> createState() =>
      _DisplayTransactionsPageState();
}

class _DisplayTransactionsPageState
    extends AuthRequiredState<DisplayTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Transactions'),
        centerTitle: true,
      ),
      body: Consumer<TransactionListChangeNotifier>(
        builder: (context, value, child) => transactionList(value),
      ),
    );
  }

  Widget transactionList(
      TransactionListChangeNotifier transactionListChangeNotifier) {
    List<Transaction> allTransactions =
        transactionListChangeNotifier.allTransactionList;
    if (!transactionListChangeNotifier.isUpToDate) {
      return const CircularProgressIndicator();
    }
    if (allTransactions.isEmpty) return const Text('No Transactions recorded');

    return ListView.builder(
        itemCount: allTransactions.length * 2 - 1,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          if (index.isOdd) return const Divider();
          return _buildRow(
              allTransactions[index ~/ 2], transactionListChangeNotifier);
        });
  }

  Widget _buildRow(Transaction transaction,
      TransactionListChangeNotifier transactionListChangeNotifier) {
    final actions = <Widget>[
      SlidableAction(
          label: 'Update',
          foregroundColor: Colors.green,
          icon: Icons.edit,
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    UpdateTransactionPage(initialTransaction: transaction)));
          }),
      SlidableAction(
          label: 'Delete',
          foregroundColor: Colors.red,
          icon: Icons.delete,
          onPressed: (context) async {
            transactionListChangeNotifier.deleteTransaction(transaction.id);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Transaction deleted'),
              duration: Duration(seconds: 2),
            ));
          })
    ];

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.6,
        children: actions,
      ),
      child: ListTile(
        title:
            Text("\$ ${transaction.amount}", style: TextStyles.optionTextStyle),
        subtitle: Text(
          "Notes: ${transaction.notes} \nTime: ${transaction.timeTransaction}",
          style: TextStyles.subOptionTextStyle,
        ),
        isThreeLine: true,
      ),
    );
  }
}
