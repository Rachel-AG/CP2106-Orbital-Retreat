import 'package:flutter/cupertino.dart';
import 'package:retreat/models/budget.dart';
import 'package:retreat/services/budget_service.dart';

/// this class manages the state of budget list for the currently authenticated user
class BudgetListChangeNotifier extends ChangeNotifier {
  final BudgetService _budgetService;
  BudgetListChangeNotifier(this._budgetService);

  List<Budget> _budgetList = List.empty();
  List<Budget> get budgetList {
    isUpToDate ? true : getAllBudget();
    return _budgetList;
  }

  bool isUpToDate = false;

  Future<void> getAllBudget() async {
    _budgetList = await _budgetService.getAllBudget();
    _sortFromLatestToEarliest();
    isUpToDate = true;
    notifyListeners();
  }

  Future<void> insertBudget(
      {required double amount, required int month, required int year}) async {
    isUpToDate = false;
    await _budgetService.insertBudget(amount: amount, month: month, year: year);

    await getAllBudget();
  }

  Future<void> updateBudget(
      {required String id,
      required double amount,
      required int month,
      required int year}) async {
    isUpToDate = false;
    await _budgetService.updateBudget(
        id: id, amount: amount, month: month, year: year);

    await getAllBudget();
  }

  Future<void> deleteBudget({required String id}) async {
    isUpToDate = false;
    await _budgetService.deleteBudget(id: id);

    await getAllBudget();
  }

  ///sorts budget with the most recent budget being at the start of the list
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
