import 'package:flutter/material.dart';
import 'package:retreat/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionService {
  final client = Supabase.instance.client;

  Future<void> insertTransaction(context, {required double amount, String? notes, required String category}) async {
    final result = await client.from('transactions').insert([
      {'amount': amount, 'notes': notes, 'category': category}
    ]).execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
  }
}