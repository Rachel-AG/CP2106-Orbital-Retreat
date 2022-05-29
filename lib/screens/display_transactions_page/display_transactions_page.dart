import 'package:flutter/material.dart';

class DisplayTransactionPage extends StatefulWidget {
  const DisplayTransactionPage({Key? key}) : super(key: key); //??

  @override
  State<DisplayTransactionPage> createState() => _DisplayTransactionPageState();
}

class _DisplayTransactionPageState extends State<DisplayTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('display transactions'),
        centerTitle: true,
      ),
      body: Text('transactionss'),
    );
  }
}

