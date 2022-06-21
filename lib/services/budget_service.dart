import 'package:flutter/material.dart';
import 'package:retreat/models/category.dart';
import 'package:retreat/services/category_service.dart';
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
  Future<Budget> getBudgetMonthYear(context, int month, int year) async {
    final result = await client
        .from('budgets')
        .select()
        .eq('month', month)
        .eq('year', year)
        .eq('created_by', client.auth.currentUser?.id)
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final data = result.data;

    return data.map((e) => Budget.fromJson(e)).toList().first;
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

  /// Retrieve Budgets that occurs within the specified time frame.
  ///
  /// [month] and [year] specify the time of the Budgets.
  /// The Budget list obtained are all expenses if [isExpense] is true.
  /// The Budget list obtained are all incomes if [isExpense] is false.
  Future<List<Budget>> getMonthBudgets(context,
      {required int month, required int year, required bool isExpense}) async {
    final result = await client
        .from('budgets')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .eq('is_expense', isExpense)
        .gte('time_Budget', DateTime.utc(year, month).toIso8601String())
        .lt('time_Budget', DateTime.utc(year, month + 1).toIso8601String())
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    }
    final dataList = result.data as List;
    return dataList.map((e) => Budget.fromJson(e)).toList();
  }


  /// Retrieve the total amount of expense/income obtained in the specified time frame.
  ///
  /// [month] and [year] specify the time of the Budgets.
  /// Total amount of expense is returned if [isExpense] is true.
  /// Total amount of income is returned if [isExpense] is false.
  Future<double> getMonthTotalBudgets(context,
      {required int month, required int year, required bool isExpense}) async {
    final BudgetList = await getMonthBudgets(context,
        month: month, year: year, isExpense: isExpense);
    return BudgetList.fold<double>(
        0.0, (previousValue, element) => previousValue + element.amount);
  }

  Future<List<double>> getTotalBudgetListByMonth(context,
      {required int year, required bool isExpense}) async {
    List<double> result = List.filled(12, 0.0);
    for (int i = 0; i < result.length; i++) {
      result[i] = await getMonthTotalBudgets(context,
          month: i + 1, year: year, isExpense: isExpense);
    }
    return result;
  }
}
