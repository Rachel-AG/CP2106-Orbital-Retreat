import 'package:flutter/cupertino.dart';
import 'package:retreat/models/budget.dart';
import 'package:retreat/services/budget_service.dart';

class BudgetListChangeNotifier extends ChangeNotifier {
  List<Budget> _budgetList = List.empty();
  List<Budget> get budgetList {
    isUpToDate ? true : getAllBudget();
    return _budgetList;
  }

  bool isUpToDate = false;

  Future<void> getAllBudget() async {
    _budgetList = await BudgetService.getAllBudget();
    _sortFromLatestToEarliest();
    isUpToDate = true;
    notifyListeners();
  }

  Future<void> insertBudget(
      {required double amount, required int month, required int year}) async {
    await BudgetService.insertBudget(amount: amount, month: month, year: year);
    isUpToDate = false;
    getAllBudget();
  }

  Future<void> updateBudget(
      {required String id,
      required double amount,
      required int month,
      required int year}) async {
    await BudgetService.updateBudget(
        id: id, amount: amount, month: month, year: year);
    isUpToDate = false;
    getAllBudget();
  }

  Future<void> deleteBudget({required String id}) async {
    await BudgetService.deleteBudget(id: id);
    isUpToDate = false;
    getAllBudget();
  }

  void _sortFromLatestToEarliest() {
    _budgetList.sort(
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
  }

  void reset() {
    _budgetList = List.empty();
    isUpToDate = false;
  }
}
