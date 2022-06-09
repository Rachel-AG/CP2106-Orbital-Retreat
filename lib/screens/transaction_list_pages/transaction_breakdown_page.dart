import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';
import 'package:retreat/services/transactions_service.dart';
import '../../models/transactions.dart';

class TransactionBreakdownPage extends StatefulWidget {
  const TransactionBreakdownPage({Key? key}) : super(key: key); //??

  @override
  State<TransactionBreakdownPage> createState() =>
      _TransactionBreakdownPageState();
}

class _TransactionBreakdownPageState
    extends AuthRequiredState<TransactionBreakdownPage> {
  final _supabaseClient = TransactionService();
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Transactions Breakdown'),
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                //Navigator.pushReplacementNamed(context, '/home');
                Navigator.canPop(context);
              },
              child: const Icon(
                Icons.home,
              ))),
      body: FutureBuilder<List<Transactions>>(
          future: _supabaseClient.getMonthTransaction(context,
              month: month, year: year),
          builder: (context, AsyncSnapshot<List<Transactions>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Text('Loading....');
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(snapshot.data.toString());
                }
            }
          }),
    );
  }
}
