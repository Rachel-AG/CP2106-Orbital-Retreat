import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/transaction.dart';

class TransactionService {
  final client = Supabase.instance.client;

  Future<void> insertTransaction(context,
      {required double amount, String? notes, required String category, 
      required DateTime timeTransaction, required bool isExpense}) async {
    final result = await client.from('transactions').insert([
      {'amount': amount, 'notes': notes, 'category': category, 
      'timeTransaction': timeTransaction.toIso8601String(), 'isExpense': isExpense}
    ]).execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  Future<void> deleteTransaction(context, {required String id}) async {
    final result = await client.from('transactions')
                               .delete()
                               .eq('id', id)
                               .execute();
    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  Future<List<Transaction>> getAllTransactions(context) async {
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
        dataList.map((e) => Transaction.fromJson(e)).toList());
  }

  Future<List<Transaction>> getAllTransactionsSorted(context) async {
    final result = await client
        .from('transactions')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .eq('isExpense', true)
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final dataList = result.data as List;

    List<Transaction> resultList = List.from(
        dataList.map((e) => Transaction.fromJson(e)).toList());

    resultList.sort((a, b) {
          var adate = a.timeTransaction;
          var bdate = b.timeTransaction;
          int timeTransactionCompared = -adate.compareTo(bdate);

          if(timeTransactionCompared == 0) {
            var acreate = a.timeCreated;
            var bcreate = b.timeCreated;
            return -acreate.compareTo(bcreate);
          } else {
            return timeTransactionCompared;
          }
        },);
    
    return resultList;
  }

  Future<List<Transaction>> getMonthTransaction(context,
      {required int month, required int year}) async {
    final result = await client
        .from('transactions')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .eq('isExpense', true)
        .gte('timeTransaction', DateTime.utc(year, month).toIso8601String())
        .lt('timeTransaction', DateTime.utc(year, month + 1).toIso8601String())
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
    return dataList.map((e) => Transaction.fromJson(e)).toList();
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
      {required List<Transaction> transactionList}) async {
    final categoryList = await getAllCategories(context);
    final amountList = List<double>.filled(categoryList.length, 0.0);
    for (var element in transactionList) {
      int index =
          categoryList.indexWhere((category) => category == element.category);
      amountList[index] += element.amount;
    }
    return Map.fromIterables(categoryList, amountList);
  }

  Future<Map<String, double>> getBreakdownByCategoryFromTime(context,
      {required int month, required int year}) async {
    final transactionList =
        await getMonthTransaction(context, month: month, year: year);
    return getBreakdownByCategoryFromList(context,
        transactionList: transactionList);
  }
}
