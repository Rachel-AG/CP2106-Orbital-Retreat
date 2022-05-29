import 'package:flutter/material.dart';
import 'package:retreat/services/display_transactions.dart';

import '../../models/transactions.dart';

class DisplayTransactionsPage extends StatefulWidget {
  const DisplayTransactionsPage({Key? key}) : super(key: key); //??

  @override
  State<DisplayTransactionsPage> createState() =>
      _DisplayTransactionsPageState();
}

class _DisplayTransactionsPageState extends State<DisplayTransactionsPage> {
  final _supabaseClient = DisplayTransactionsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('display transactions'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Transactions>>(
        future: _supabaseClient.getTransactions(context),
        builder: (context, AsyncSnapshot<List<Transactions>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text('Loading....');
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text('Result: ${snapshot.data}');
              }
          }
        },
      ),
    );
  }
}
