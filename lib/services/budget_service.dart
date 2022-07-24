import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/budget.dart';

class BudgetService {
  final client = Supabase.instance.client;

  ///Inserts budget to the database
  Future<void> insertBudget(context,
      {required double amount,
      required int month,
      required int year}) async {
    final result = await client.from('budgets').insert([
      {
        'amount': amount,
        'month': month,
        'year': year
      }
    ]).execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  /// Deletes Budget
  Future<void> deleteBudget(context, {required String id}) async {
    final result = await client.from('budgets').delete().eq('id', id).execute();
    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  Future<bool> updateBudget(context,
      {required String id,
      required double amount,
      required int month,
      required int year}) async {
    final result = await client
        .from('budgets')
        .update({
          'amount': amount,
        })
        .eq('month', month)
        .eq('year', year)
        .eq('id', id)
        .execute();

    // check if Budget is updated successfully
    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return true;
  }

  /// Retrieves a Budget based on id 
  Future<Budget> getBudget(context, String id) async {
    final result = await client
        .from('budgets')
        .select()
        .eq('id', id)
        .eq('created_by', client.auth.currentUser?.id)
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final data = result.data;

    return data.map((e) => Budget.fromJson(e));
  }

  /// Retrieves a Budget based on month and year 
  Future<Budget?> getBudgetMonthYear(context, {required int month, required int year}) async {
    final result = await client
        .from('budgets')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .eq('month', month)
        .eq('year', year)
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final dataList = result.data as List;

    final convertedList = List.from(dataList.map((e) => Budget.fromJson(e)).toList());
    if(convertedList.isEmpty) {
      return null;
    } else {
      return convertedList.elementAt(0);
    }
  }

  /// Retrieves all Budgets recorded by the user
  Future<List<Budget>> getAllBudgets(context) async {
    final result = await client
        .from('budgets')
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

    return List.from(dataList.map((e) => Budget.fromJson(e)).toList());
  }

  /// Retrieves all Budgets recorded by the user that are sorted based on time
  Future<List<Budget>> getAllBudgetsSorted(context) async {
    final result = await client
        .from('budgets')
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

    List<Budget> resultList =
        List.from(dataList.map((e) => Budget.fromJson(e)).toList());

    resultList.sort(
      (a, b) {
        var adate = a.year;
        var bdate = b.year;
        int timeBudgetCompared = -adate.compareTo(bdate);

        if (timeBudgetCompared == 0) {
          var acreate = a.month;
          var bcreate = b.month;
          return -acreate.compareTo(bcreate);
        } else {
          return timeBudgetCompared;
        }
      },
    );

    return resultList;
  }

}
