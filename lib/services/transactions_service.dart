import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:retreat/models/transaction.dart';

class TransactionService {
  static final client = Supabase.instance.client;

  Future<List<Transaction>> getAllTransactions() async {
    final result = await client
        .from('transactions')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .execute();

    final dataList = result.data as List;
    return List.from(dataList.map((e) => Transaction.fromJson(e)).toList());
  }

  Future<bool> insertTransaction(
      {required double amount,
      String? notes,
      required int categoryId,
      required DateTime timeTransaction,
      required bool isExpense}) async {
    final result = await client.from('transactions').insert([
      {
        'amount': amount,
        'notes': notes,
        'category_id': categoryId,
        'time_transaction': timeTransaction.toIso8601String(),
        'is_expense': isExpense,
      }
    ]).execute();

    if (result.error != null) return false;
    return true;
  }

  Future<bool> deleteTransaction(String id) async {
    final result =
        await client.from('transactions').delete().eq('id', id).execute();

    if (result.error != null) return false;
    return true;
  }

  Future<bool> updateTransaction(
      {required String id,
      required double amount,
      String? notes,
      required int categoryId,
      required DateTime timeTransaction,
      required bool isExpense}) async {
    final result = await client
        .from('transactions')
        .update({
          'amount': amount,
          'notes': notes,
          'category_id': categoryId,
          'time_transaction': timeTransaction.toIso8601String(),
          'is_expense': isExpense,
        })
        .eq('id', id)
        .execute();

    if (result.error != null) {
      print(result.error?.message);
      return false;
    }
    return true;
  }

  /// Deletes transaction
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

  Future<bool> updateTransaction(context,
      {required String id,
      required double amount,
      String? notes,
      required int categoryId,
      required DateTime timeTransaction,
      required bool isExpense}) async {
    final result = await client
        .from('transactions')
        .update({
          'amount': amount,
          'notes': notes,
          'category_id': categoryId,
          'time_transaction': timeTransaction.toIso8601String(),
          'is_expense': isExpense
        })
        .eq('id', id)
        .execute();

    // check if transaction is updated successfully
    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
      return false;
    }
    return true;
}

  /// Retrieves a transaction
  Future<List<Transaction>> getTransaction(context, String id) async {
    final result = await client
        .from('transactions')
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

    return data.map((e) => Transaction.fromJson(e));
  }

  /// Retrieves all transactions recorded by the user
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

  /// Retrieves all transactions recorded by the user that are sorted as following:
  /// transaction with the most recent date of transaction is at the top most
  /// if the date of transaction is the same, the one that was recorded last is on top
  Future<List<Transaction>> getAllTransactionsSorted(context) async {
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

  Future<double> sumMonthTransactions(context,
      {required int month, required int year, required bool isExpense}) async {
    final result = await client
        .from('transactions')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .eq('is_expense', isExpense)
        .gte('time_transaction', DateTime.utc(year, month).toIso8601String())
        .lt('time_transaction', DateTime.utc(year, month + 1).toIso8601String())
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    } 
    final dataList = result.data as List;
    List<Transaction> transactionList = dataList.map((e) => Transaction.fromJson(e)).toList();
    List<double> amountList = transactionList.map((e) => e.amount).toList();
    double sum = amountList.fold(0, (p, c) => p + c);
    return sum;
  }

  /// Retrieve transactions that occurs within the specified time frame.
  ///
  /// [month] and [year] specify the time of the transactions.
  /// The transaction list obtained are all expenses if [isExpense] is true.
  /// The transaction list obtained are all incomes if [isExpense] is false.
  Future<List<Transaction>> getMonthTransactions(context,
      {required int month, required int year, required bool isExpense}) async {
    final result = await client
        .from('transactions')
        .select()
        .eq('created_by', client.auth.currentUser?.id)
        .eq('is_expense', isExpense)
        .gte('time_transaction', DateTime.utc(year, month).toIso8601String())
        .lt('time_transaction', DateTime.utc(year, month + 1).toIso8601String())
        .execute();

    if (result.error?.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${result.error!.message.toString()}'),
        duration: const Duration(seconds: 2),
      ));
    } 
    final dataList = result.data as List;
    return dataList.map((e) => Transaction.fromJson(e)).toList();
  }

  /// Retrieve the total amount of money in each category based on a list of transactions.
  ///
  /// [transactionList] is the list of transactions to be calculated.
  /// The list of categories used are Expenses' categories if [isExpense] is true.
  /// The list of categories used are Incomes' categories if [isExpense] is false.
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
          .indexWhere((category) => category.id == element.categoryId);
      amountList[index] += element.amount;
    }

    var result = Map.fromIterables(categoryList,
        amountList.map((e) => double.parse((e).toStringAsFixed(2))));
    result.removeWhere((key, value) => value == 0.0);
    return result;
  }

  /// Retrieve the total amount of money in each category based on transactions that occur in specified time frame.
  ///
  /// [month] and [year] specify the time of the transactions.
  /// The list of categories used are Expenses' categories if [isExpense] is true.
  /// The list of categories used are Incomes' categories if [isExpense] is false.
  Future<Map<Category, double>> getBreakdownByCategoryFromTime(context,
      {required int month, required int year, required bool isExpense}) async {
    final transactionList = await getMonthTransactions(context,
        month: month, year: year, isExpense: isExpense);
    return getBreakdownByCategoryFromList(context,
        transactionList: transactionList, isExpense: isExpense);
  }

  /// Retrieve the total amount of expense/income obtained in the specified time frame.
  ///
  /// [month] and [year] specify the time of the transactions.
  /// Total amount of expense is returned if [isExpense] is true.
  /// Total amount of income is returned if [isExpense] is false.
  Future<double> getMonthTotalTransactions(context,
      {required int month, required int year, required bool isExpense}) async {
    final transactionList = await getMonthTransactions(context,
        month: month, year: year, isExpense: isExpense);
    return transactionList.fold<double>(
        0.0, (previousValue, element) => previousValue + element.amount);
  }

  Future<List<double>> getTotalTransactionListByMonth(context,
      {required int year, required bool isExpense}) async {
    List<double> result = List.filled(12, 0.0);
    for (int i = 0; i < result.length; i++) {
      result[i] = await getMonthTotalTransactions(context,
          month: i + 1, year: year, isExpense: isExpense);
    }
    return result;
  }
}
