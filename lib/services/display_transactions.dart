import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/transactions.dart';

class DisplayTransactionsService {
  final client = Supabase.instance.client;

  Future<List<Transactions>> getTransactions(context) async {

    final result = await client
        .from('transactions')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final dataList = result.data as List;

    return List.from(dataList.map((e) => Transactions.fromJson(e)).toList().reversed);
  }
}