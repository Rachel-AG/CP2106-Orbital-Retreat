import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/constants/app_colors.dart';
import 'package:retreat/services/transactions_service.dart';
import '../../models/transactions.dart';

class DisplayTransactionsPage extends StatefulWidget {
  const DisplayTransactionsPage({Key? key}) : super(key: key); //??

  @override
  State<DisplayTransactionsPage> createState() =>
      _DisplayTransactionsPageState();
}

class _DisplayTransactionsPageState
    extends AuthRequiredState<DisplayTransactionsPage> {
  final _supabaseClient = TransactionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Transactions'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Transactions>>(
          future: _supabaseClient.getAllTransactions(context),
          builder: (context, AsyncSnapshot<List<Transactions>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Text('Loading....');
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                  // } else if (!snapshot.hasData || snapshot.data == null) {
                  //   return const Text('You have not recorded any transactions');
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      var transaction = snapshot.data?[index];
                      String amountString =
                          transaction?.amount.toString() ?? "No amount";
                      String notesString = transaction?.notes ?? "";
                      String timeStamp =
                          transaction?.time.substring(0, 10) ?? "";
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                                width: 1.0,
                                style: BorderStyle.solid,
                                color: AppColors.steelteal)),
                        margin: const EdgeInsets.all(12.0),
                        child: ListTile(
                          title: Text("\$ $amountString"),
                          subtitle:
                              Text("Notes: $notesString \nTime: $timeStamp"),
                          isThreeLine: true,
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
