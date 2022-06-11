import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/transactions.dart';

class TransactionService {
  final client = Supabase.instance.client;

  Future<void> insertTransaction(context,
      {required double amount, String? notes, required String category}) async {
    final result = await client.from('transactions').insert([
      {'amount': amount, 'notes': notes, 'category': category}
    ]).execute();

    // NO ERROR HANDLING
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
    } else if (result.data == null) {
      print('no transactions recorded');
    }
    final dataList = result.data as List;
    return dataList.map((e) => Transactions.fromJson(e)).toList();
  }

  Future<List<String>> getAllCategories(context) async {
    return <String>[
      'Education',
      'Entertainment',
      'Food & Drink',
      'Groceries',
      'Health',
      'Housing',
      'Tax',
      'Transportation',
      'Utilities',
      'Work',
      'Others',
    ];
  }

  Future<Map<String, double>> getBreakdownByCategoryFromList(context,
      {required List<Transactions> transactionList}) async {
    final categoryList = await getAllCategories(context);
    final amountList = List<double>.filled(categoryList.length, 0.0);
    for (var element in transactionList) {
      int index =
          categoryList.indexWhere((category) => category == element.category);
      amountList[index] += element.amount;
    }

    var result = Map.fromIterables(categoryList,
        amountList.map((e) => double.parse((e).toStringAsFixed(2))));
    result.removeWhere((key, value) => value == 0.0);
    return result;
  }

  Future<Map<String, double>> getBreakdownByCategoryFromTime(context,
      {required int month, required int year}) async {
    final transactionList =
        await getMonthTransaction(context, month: month, year: year);
    return getBreakdownByCategoryFromList(context,
        transactionList: transactionList);
  }

  // TODO: BreakdownByExpenseFromList, BreakdownByExpenseFromTime
  // TODO: BreakdownByIncomeFromList, BreakdownByIncomeFromTime

}
