import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retreat/models/transaction.dart';
import 'package:retreat/services/transactions_service.dart';

class TransactionListChangeNotifier extends ChangeNotifier {
  List<Transaction> _allTransactionList = List<Transaction>.empty();
  List<Transaction> get allTransactionList {
    isUpToDate ? true : getAllTransactions();
    return _allTransactionList;
  }

  bool isUpToDate = false;

  Future<void> getAllTransactions() async {
    _allTransactionList = await TransactionService.getAllTransactions();
    _sortLatestToEarliest();
    isUpToDate = true;
    notifyListeners();
  }

  Future<void> insertTransaction(
      {required double amount,
      String? notes,
      required int categoryId,
      required DateTime timeTransaction,
      required bool isExpense}) async {
    await TransactionService.insertTransaction(
        amount: amount,
        notes: notes,
        categoryId: categoryId,
        timeTransaction: timeTransaction,
        isExpense: isExpense);
    isUpToDate = false;
    getAllTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await TransactionService.deleteTransaction(id);
    isUpToDate = false;
    getAllTransactions();
  }

  Future<void> updateTransaction(
      {required String id,
      required double amount,
      String? notes,
      required int categoryId,
      required DateTime timeTransaction,
      required bool isExpense}) async {
    await TransactionService.updateTransaction(
        id: id,
        amount: amount,
        notes: notes,
        categoryId: categoryId,
        timeTransaction: timeTransaction,
        isExpense: isExpense);
    isUpToDate = false;
    getAllTransactions();
  }

  /// Sorted as following:
  /// Transaction with the most recent date of transaction is at the top most.
  /// If the date of transaction is the same, the one that was recorded last is on top.
  void _sortLatestToEarliest() {
    _allTransactionList.sort(
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
  }

  void _sortEarliestToLatest() {
    _allTransactionList.sort(
      (a, b) {
        var adate = a.timeTransaction;
        var bdate = b.timeTransaction;
        int timeTransactionCompared = adate.compareTo(bdate);

        if (timeTransactionCompared == 0) {
          var acreate = a.timeCreated;
          var bcreate = b.timeCreated;
          return acreate.compareTo(bcreate);
        } else {
          return timeTransactionCompared;
        }
      },
    );
  }

  void reset() {
    _allTransactionList = List<Transaction>.empty();
    isUpToDate = false;
  }
}
