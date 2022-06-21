import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/constants/text_styles.dart';
import 'package:retreat/screens/update_transaction_page/update_transaction_page.dart';
import 'package:retreat/services/transactions_service.dart';
import '../../models/transaction.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

class DisplayTransactionsPage extends StatefulWidget {
  const DisplayTransactionsPage({Key? key}) : super(key: key); //??

  @override
  State<DisplayTransactionsPage> createState() =>
      _DisplayTransactionsPageState();
}

class _DisplayTransactionsPageState
    extends AuthRequiredState<DisplayTransactionsPage> {
  final _supabaseClient = TransactionService();

  Future delete(String id) async {
    await _supabaseClient.deleteTransaction(context, id: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('My Transactions'),
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
              child: const Icon(
                Icons.home,
              ))),
      body: FutureBuilder<List<Transaction>>(
          future: _supabaseClient.getAllTransactionsSorted(context),
          builder: (context, AsyncSnapshot<List<Transaction>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Text('Loading....');
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                  // } else if (!snapshot.hasData || snapshot.data == null) {
                  //   return const Text('You have not recorded any transactions');
                } else {
                  var transactions = snapshot.data;
                  return ListView.builder(
                    itemCount: transactions?.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      var transaction = transactions?[index];
                      String amountString =
                          transaction?.amount.toString() ?? "No amount";
                      String notesString = transaction?.notes ?? "";
                      String timeTransaction =
                          transaction?.timeTransaction ?? "No date";
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                                width: 1.0,
                                style: BorderStyle.solid,
                                color: AppColors.steelteal)),
                        margin: const EdgeInsets.all(12.0),
                        child: ListTile(
                          title: Text("\$ $amountString", style: TextStyles.optionTextStyle),
                          subtitle: Text(
                              "Notes: $notesString \nTime: $timeTransaction", 
                              style: TextStyles.subOptionTextStyle,),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>UpdateTransactionPage(initialTransaction: transaction!)));
                                  }),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await delete(transaction?.id ?? "").then( 
                                        (_) => ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Transaction deleted'),
                                              duration: Duration(seconds: 2),
                                            )));
                                    setState(() {
                                      transactions?.remove(transaction);
                                    });
                                  }),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
            }
          }),
    );
  }
}
