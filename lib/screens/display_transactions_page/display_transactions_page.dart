import 'package:flutter/material.dart';
import 'package:retreat/constants/auth_required_state.dart';

class DisplayTransactionPage extends StatefulWidget {
  const DisplayTransactionPage({Key? key}) : super(key: key); //??

  @override
  State<DisplayTransactionPage> createState() => _DisplayTransactionPageState();
}

class _DisplayTransactionPageState
    extends AuthRequiredState<DisplayTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('display transactions'),
        centerTitle: true,
      ),
      body: const Text('transactionss'),
    );
  }
}
