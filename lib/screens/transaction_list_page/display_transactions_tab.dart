import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/models/transaction.dart';
import 'package:retreat/notifiers/category_list_change_notifier.dart';
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
      body:
          Consumer2<TransactionListChangeNotifier, CategoryListChangeNotifier>(
        builder: (context, value, value2, child) =>
            transactionList(value, value2),
      ),
    );
  }

  Widget transactionList(
      TransactionListChangeNotifier transactionListChangeNotifier,
      CategoryListChangeNotifier categoryListChangeNotifier) {
    List<Transaction> allTransactions =
        transactionListChangeNotifier.allTransactionList;
    if (!transactionListChangeNotifier.isUpToDate) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
        ],
      );
    }
    if (allTransactions.isEmpty) return const Text('No Transactions recorded');

    String date = '';

    return ListView.builder(
        itemCount: allTransactions.length * 2,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          if (index.isEven && index ~/ 2 < allTransactions.length) {
            if (allTransactions[index ~/ 2].timeTransaction == date) {
              return const SizedBox();
            }
            date = allTransactions[index ~/ 2].timeTransaction;
            return Container(
                color: AppColors.custom.shade100.withOpacity(0.4),
                child: Text(date));
          }
          return _buildRow(allTransactions[index ~/ 2],
              transactionListChangeNotifier, categoryListChangeNotifier);
        });
  }

  Widget _buildRow(
      Transaction transaction,
      TransactionListChangeNotifier transactionListChangeNotifier,
      CategoryListChangeNotifier categoryListChangeNotifier) {
    final actions = <Widget>[
      SlidableAction(
          label: 'Update',
          autoClose: true,
          foregroundColor: AppColors.green,
          icon: Icons.edit,
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    UpdateTransactionPage(initialTransaction: transaction)));
          }),
      SlidableAction(
          label: 'Delete',
          foregroundColor: AppColors.red,
          icon: Icons.delete,
          onPressed: (context) async {
            transactionListChangeNotifier.deleteTransaction(transaction.id);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Transaction deleted'),
              duration: Duration(seconds: 2),
            ));
          })
    ];

    String category = categoryListChangeNotifier
        .getCategoryNameFromId(transaction.categoryId);

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.6,
        children: actions,
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category, style: TextStyles.optionTextStyle),
            Text("\$ ${transaction.amount}",
                style: transaction.isExpense
                    ? TextStyles.expenseAmount
                    : TextStyles.incomeAmount),
          ],
        ),
        subtitle: Text(
          "Notes: ${transaction.notes}",
        ),
      ),
    );
  }
}
