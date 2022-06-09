import 'package:flutter/material.dart';
import 'package:retreat/models/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/transactions.dart';

class TransactionService {
  final client = Supabase.instance.client;

  Future<void> insertTransaction(context,
      {required double amount, String? notes, required String category}) async {
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

  Future<List<Transactions>> getAllTransactions(context) async {
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

    return List.from(
        dataList.map((e) => Transactions.fromJson(e)).toList().reversed);
  }

  Future<List<Transactions>> getMonthTransaction(context,
      {required int month, required int year}) async {
    final result = await client
        .from('transactions')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .gte('time', DateTime.utc(year, month).toIso8601String())
        .lt('time', DateTime.utc(year, month + 1).toIso8601String())
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final dataList = result.data as List;
    return dataList.map((e) => Transactions.fromJson(e)).toList();
  }

  //NOT TESTED: MIGHT NOT WORK PROPERLY DUE TO SUPABASE POLICY
  Future<List<Category>> getCategories(context) async {
    final result = await client.from('categories').select().execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final dataList = result.data as List;
    return dataList.map((e) => Category.fromJson(e)).toList();
  }
}
