import 'package:flutter/material.dart';
import 'package:retreat/models/category.dart';
import 'package:retreat/services/category_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/transaction.dart';

class TransactionService {
  final client = Supabase.instance.client;

  Future<void> insertTransaction(context,
      {required double amount,
      String? notes,
      required String category,
      required DateTime timeTransaction,
      required bool isExpense}) async {
    final result = await client.from('transactions').insert([
      {
        'amount': amount,
        'notes': notes,
        'category': category,
        'timeTransaction': timeTransaction.toIso8601String(),
        'isExpense': isExpense
      }
    ]).execute();

    // NO ERROR HANDLING
    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  Future<void> deleteTransaction(context, {required String id}) async {
    final result =
        await client.from('transactions').delete().eq('id', id).execute();
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

    return List.from(dataList.map((e) => Transaction.fromJson(e)).toList());
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

    List<Transaction> resultList =
        List.from(dataList.map((e) => Transaction.fromJson(e)).toList());

    resultList.sort(
      (a, b) {
        var adate = a.timeTransaction;
        var bdate = b.timeTransaction;
        int timeTransactionCompared = -adate.compareTo(bdate);

        if (timeTransactionCompared == 0) {
          var acreate = a.timeCreated;
          var bcreate = b.timeCreated;
          return -acreate.compareTo(bcreate);
        } else {
          return timeTransactionCompared;
        }
      },
    );

    return resultList;
  }

  Future<List<Transaction>> getMonthTransactions(context,
      {required int month, required int year, required bool isExpense}) async {
    final result = await client
        .from('transactions')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .eq('isExpense', isExpense)
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

  Future<Map<Category, double>> getBreakdownByCategoryFromList(context,
      {required List<Transaction> transactionList,
      required bool isExpense}) async {
    final categoryList = isExpense
        ? await CategoryService.getExpenseCategories(context)
        : await CategoryService.getIncomeCategories(context);
    final amountList = List<double>.filled(categoryList.length, 0.0);
    for (var element in transactionList) {
      // optimization: compare using category id instead
      int index = categoryList
          .indexWhere((category) => category.name == element.category);
      amountList[index] += element.amount;
    }

    var result = Map.fromIterables(categoryList,
        amountList.map((e) => double.parse((e).toStringAsFixed(2))));
    result.removeWhere((key, value) => value == 0.0);
    return result;
  }

  Future<Map<Category, double>> getBreakdownByCategoryFromTime(context,
      {required int month, required int year, required bool isExpense}) async {
    final transactionList = await getMonthTransactions(context,
        month: month, year: year, isExpense: isExpense);
    return getBreakdownByCategoryFromList(context,
        transactionList: transactionList, isExpense: isExpense);
  }
}
